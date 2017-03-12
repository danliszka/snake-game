Dan Liszka: dal148@pitt.edu
Jen Gingerich: 

FUNCTIONS USED
_setLED: given with project
_getLED: given with project

_updateSnake: written to take the memory of the tail address and head address and set the
new head coordinate and delete the old tail coordinate. Decisions on where the new head will be and if the tail will be deleted (due to whether a green frog was eaten) will be dictated by the function _moveSnake. _updateSnake will be an inner function of _moveSnake

_moveSnake: 

INITIALIZATION
To begin the program before the snake starts moving, the board outline is read in using a string to compare where a red light should be. after that, the snake is placed on the board and green lights are placed randomly in the black spaces using a random syscall.


