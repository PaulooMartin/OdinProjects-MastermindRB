Reference so that I do not have to read every code and just quickly reference stuff.
Code that do not need to be documented or are understandable-on-read just don't need to be documented.

## Legend

```
^ General information
=> Return value
```

## Code
```
>- module CheckPlacements
check_correct_placements
check_incorrect_placements
transform_equals_at_placements
^ Accompanies checking of incorrect placement so to comparing those numbers that are already in the right place
```
```
>- Class Game
Initialize
start
^ starts the mastermind game

private

give_feedback_on_guess
end_message
start_message
start_message_creator
start_message_guesser
human_choose_role
switch_roles
```

```
>- Class Player
Initialize
make_combination
^ Just collected all the make-combination of computer and human
guess_combination
^ Just collected all the guess-combination of computer and human

private

make_combination_computer
guess_combination_computer
remove_improbable_guesses
^ Computer's algorithm for making a guess
all_possible_combination
^ Generates initial set of guesses for the computer
combination_human
```