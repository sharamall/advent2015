[
™ is a breakpoint that can be hit in the interpreter
^ is a custom extension to substitute a file like #include in c/c++
]

^day01input

cells
minus 1         0                      1             2 ??        3
  sum     current_char    temp_cell_for_ascii_check          position
>>>>+<<<< // set flag to check for basement for part2
: read in first char
[ begin read loop
    >[-] move to temp_cell_for_ascii_check and clear


    ascii 40 is ( 41 is ) subtract 40 here and see if result is 0
    this does 4 times 10

    ++++ set temp_cell_for_ascii_check to 4
    (4 down to 0) each subtract 10 from current_char cell
    [<---------->-]

    < move back to where we read in char

    if result is 1 then we saw a ) otherwise it was a (

    >>>+<<< // increment position

    [ // if the char was )

        - // subtract 1 to reset cell to zero
        < // move to cell minus 1 which holds the sum

            // we have to make a copy of the current flag in cell 5 because
            // in order to exit the loop the cell must be zero
            // copy the flag from cell 4 to 5 and then use cell 5 to determine whether
            // we should enter the loop
            // always reset 5 to zero so that the bracket functions as an if statement rather than a loop
            // with a side effect of modifying cell 4 as necessary

            >>>>> // move to cell 4 which is flag that part 2 has been found
            [->+>+<<]>>[-<<+>>] // copy cell 4 to cell 5 using cell 6 as temp
            < // move to cell 5 from temporary 6
            // check if sum is zero
            [ // check flag because once we find basement we do not check this again
                <<<<<< // revert to cell minus 1
                >>[-] // move to cell1 and reset it to 0
                >[-] // reset cell2 to 0
                <<<[->>+>+<<<] // copy sum into cell1 and cell2 and reset sum
                >>>[-<<<+>>>] // move cell2 to cell minus 1 which restores the sum
                // end at cell2 which is zero
                // negate cell1 function which holds the copied sum
                    + // set cell2 to 1
                    < // move to cell1

                    [ // if cell1 is non zero
                        [-] // reset it to zero
                        >-< // set cell2 to zero which is the negation then move back to cell1
                    ]
                    > // move to cell2
                    [ // else cell1 is zero because cell2 is not zero
                    - // reset cell2 to zero
                    <+ // set cell1 to one
                    >  // move to cell2 so the algorithm ends on the same cell
                    ]
                    < move to cell1

                    // cell1 is 1 if it was originally zero which means a wrap will happen if the subtraction goes through
                    // that also means for part 2 that we are entering the basement
                    [ // if cell1 is not zero
                     ™
                     >>>-<<< // unset flag
                     // todo print out the position here instead of breakpoint
                     [-]
                    ]
                >>>> // go to cell5
                [-] // always set to 0 to exit subroutine
            ]<<<<<< // go back to cell minus 1 to decrement sum
        -- // decrement twice since we always increment by 1 after this
        > // move to cell0
    ]
    if input is a ( then we skip the decrements
    always add one here
    an open paren will be negative two plus one for a net negative one
    This is more simple than a full if else statement

    move left on cell before increment
    the total cell is one left of input cell
    <+

    >: // move to cell0 and read next char
] // end read loop
#
<
™ // todo print cell as number from wiki

