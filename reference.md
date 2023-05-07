Reference so that I do not have to read every code and just quickly reference stuff.
Code that do not need to be documented or are understandable-on-read just don't need to be documented.

## Legend

```
^ General information
=> Return value
```

## Code

```
>- Class Game
Initialize
start
^ starts the mastermind game

private

give_feedback_on_guess
check_correct_placements
=> total number of correct placements of correct digits
check_incorrect_placements
=> total number of incorrect placements of correct digits
```

```
>- Class Player
Initialize
make_combination
^ Just collected all the make-combination of computer and human

private

make_combination_computer
combination_human
```

## TODO

1. Refactor getting combination for human
1. Prints history after every wrong guess
1. Win/lose message ☑️
1. Error messages for invalid guess (wrong digit used)
1. Starting options (switching roles, humanvshuman)
1. Computer (guesser) vs Human (maker)
1. Computer guessing algorithm
