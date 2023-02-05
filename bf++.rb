require "io/console"
$filename = ARGV[0]
$filename = "day01/day01.bf" if $filename.nil?
$bit_width = 16
$allow_signed = false

if $filename.chomp.empty?
  puts "No input file provided."
  exit(1)
end

class Block
  @commands
  @line
  attr_reader :commands

  def initialize(line)
    @commands = []
    @line = line
  end

  def to_s
    "Block:#{@line}=#{@commands.inspect}"
  end
end

class BfInterpreter
  @tape
  @head
  @iterations
  @line
  @char
  @file

  def initialize
    @tape = {}
    @head = 0
    @tape[0] = 0
    @iterations = 0
    @line = 1
    @char = 1
    @file = nil
  end

  def run(input)
    # todo allow reading from any file
    until input.eof? # max program length
      char = input.readchar
      process_char char, input
    end
  end

  def process_char(c, input)
    if c == ">"
      @head += 1
    elsif c == "<"
      @head -= 1
    elsif c == "+"
      @tape[@head] = 0 unless @tape.key? @head
      @tape[@head] += 1
      @tape[@head] = 0 if @tape[@head] == 2 ** $bit_width # cells are only 1 byte wide
    elsif c == "-"
      @tape[@head] = 0 unless @tape.key? @head
      @tape[@head] -= 1
      @tape[@head] = 2 ** $bit_width - 1 if @tape[@head] == -1 # cells are only 1 byte wide
    elsif c == "."
      @tape[@head] = 0 unless @tape.key? @head
      print @tape[@head].chr
    elsif c == ","
      @tape[@head] = STDIN.getch.ord
    elsif c == "["
      run_block(read_block(input), input) # always a new block if char is [, parsed blocks are classes
    elsif c.is_a? Block
      run_block({ command: c, line: @line }, input)
    elsif c == "\n"
      @line += 1
    elsif c == "#"
      if @file.nil?
        filename = File.dirname $filename
        filename += "/"
        temp_head = @head
        @tape[temp_head] = 0 unless @tape.key? temp_head
        until @tape[temp_head] == 0
          filename += @tape[temp_head].chr
          temp_head += 1
          @tape[temp_head] = 0 unless @tape.key? temp_head
        end
        begin
          @file = File.open filename
          @tape[@head] = 0
        rescue IOError => e
          puts "Cannot open file #{e}"
          @tape[@head] = 255
        end
      else
        @file.close
        @file = nil
      end
    elsif c == "™"
      print "" # breakpoint
    elsif c == ":"
      if @file.eof?
        @tape[@head] = 0
      else
        @tape[@head] = @file.readchar.ord
      end
    elsif c == "^"
      filename = File.dirname $filename
      filename += "/"
      char = input.readchar
      until char == "\n"
        filename += char
        char = input.readchar
      end
      filename += ".bf"
      included_file = File.open filename, "r"
      line_before = @line
      @line = 0
      run(included_file)
      @line = line_before + 1
      included_file.close
    end
  end

  def run_block(block, input)
    @tape[@head] = 0 unless @tape.key? @head
    while @tape[@head] != 0
      block[:command].commands.each do |c|
        @line = c[:line]
        process_char(c[:command], input)
      end
      @tape[@head] = 0 unless @tape.key? @head
    end
    @line = block[:line]
  end

  def read_block(input)
    block = Block.new @line
    char = input.readchar
    file_offset = input.tell
    begin
      while char != "]"
        if char == "["
          block.commands << read_block(input)
        elsif %w[+ - < > . ,  # : ™].include? char
          block.commands << { command: char, line: @line }
        elsif char == "\n"
          @line += 1
        end
        char = input.readchar
      end
    rescue
      puts "Unmatched ], head #{@head}, line #{@line} offset #{file_offset}"
      exit(1)
    end
    {
      line: @line,
      command: block
    }
  end
end

begin
  f = File.open $filename, "r"
  BfInterpreter.new.run f
rescue IOError => e
  puts "Could not open file \"#{$filename}\" e"
  exit(1)
end
