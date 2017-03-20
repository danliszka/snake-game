Dan Liszka: dal148@pitt.edu
Jenn Gingerich: jag236@pitt.edu

FUNCTIONS USED
_setLED: given with project
_getLED: given with project

_updateSnake: written to take the memory of the tail address and head address and set the
new head coordinate and delete the old tail coordinate. Decisions on where the new head will be and if the tail will be deleted (due to whether a green frog was eaten) will be dictated by the function _moveSnake. _updateSnake will be an inner function of _moveSnake

_moveSnake: This searches to see if a button is pressed. If yes, it will determine if the button is a legal button to press. If it is legal then the x and y increment registers will be changed to 0, 1, or -1 each. Then the new coordinates of the next head will be calculated by adding the increment registers to the old x and y values of the head. It will test to see if the coordinates of the new head location are on the edge (about to pass through the side of the board). If this is the case, then it will output the next yellow dot on the opposite side of the board where it is going into and continue to move from there. Then it will check the next LED given by the next position, and depending on what light is next, it will move to the right or left (if red), end the game (if yellow), keep moving in that direction (black), or increment the head but do not delete the tail to make it larger (if green). This function is also in charge of incrementing the memory location of where the head coordinates are stored. It is basically the brains of the whole system.

More detailed for the reactions to the different colors:

red: will move the snake automatically to the right and if there is another red on the right, will move to the left. If there are walls on both left and right then it will be considered stuck and end the game. Also if a snake is directly next to a wall moving with it and the user tries to steer into said wall, it will be ignored and the snake will keep its heading. 

green: will place the new head coordinate over the green, it will increment register s3 keeping track of how many frogs were eaten, and it will skip deleting the tail (writing the led to black, deleting the memory, and incrementing the tail memory address) by skipping the _updateSnake function.

black: just uses the direction increment registers and adds to the old head then stores the new head in the new head memory address for _updateSnake to write to the screen.

yellow: just ends the game

_delay: This function records the initial system time and keeps cycling through a loop until 200 ms have passed on the system time. It does a jump $ra back to the main



INITIALIZATION
To begin the program before the snake starts moving, the board outline is read in using a string to compare where a red light should be. after that, the snake is placed on the board and green lights are placed randomly in the black spaces using a random syscall.

DURING GAME
From there, the whole game is controlled by a main loop that has a delay, a count of the delay to get total game time, the _moveSnake function, and a fail/safe so the loop can’t run forever if a user forgets about it.

END
At the end of the game, it multiplies how many times the delay function was called by 200 to calculate the total game time in ms. It is then printed out using syscall along with the number of frogs that were eaten.

———————————

There are many comments that also explain each process very well in the assembly that you should take a look at. Below are what the storage registers are storing throughout the whole game:

#s0 will store increment for x
#s1 will store increment for y
#s2 will store game time
#s3 will store number of frogs snake has eaten
#s4 will store head address of snake
#s5 will store tail address of snake
#s6 will store beginning of space for snake addresses
#s7 will store end of space for snake addresses

temporary registers are used throughout the whole game and hold varying useful information. If you want any other specific information while grading about the assembly that we forgot to provide, please email us.


