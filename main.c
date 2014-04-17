/*
 *  Copyright 2014 by Wade T. Cline
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <stdio.h>

#include "cpc.h"
#include "board.h"

main() {
	struct board board;
	unsigned char input;
	int status; // Game status.
	int valid;

	// Print legal shenanigains.
	printf("\t2048 (implemented in C)  Copyright (C) 2014  Wade T. Cline\r\n"
	       "\tThis program comes with ABSOLUTELY NO WARRANTY. This is\r\n"
	       "\tfree software, and you are welcome to redistribute it\r\n"
	       "\tunder certain conditions. See the file 'COPYING' in the\r\n"
	       "\tsource code for details.\r\n\r\n");

	// Set up board.
	board_init(&board);
	
	
	// Play the game.
	while (!(status = board_done(&board))) {
		// Print the board.
		board_print(&board);

		// Get the player's move.
		valid = 0;
		input = GetChar_CPC();
		printf("%x \r\n", input);
		
		switch (input)
		{
			case 0x0B:	//Joystick up
			case 0x51:	//Q
			case 0x71:	//q
			case 0xF0:	//Up
				valid = board_move_up(&board);
				break;
			
			case 0x0A:	//Joystick down
			case 0x41:	//A
			case 0x61:	//a
			case 0xF1:	//Down
				valid = board_move_down(&board);
				break;
				
			case 0x08:	//Joystick left
			case 0x4F:	//O
			case 0x6F:	//o
			case 0xF2:	//Left
				valid = board_move_left(&board);
				break;
				
			case 0xFD:	//Joystick right
			case 0x50:	//P
			case 0x70:	//p
			case 0xF3:	//Right
				valid = board_move_right(&board);
				break;
			default:
				printf("Don't understand input: 0x%x.\n", input);
				continue;
		}

		// Prepare for user's next move.
		if (valid) {
			board_plop(&board);
		} else {
			printf("Invalid move.\n");
		}
	}
	
	// Print the final board.
	printf("Game over, you %s!\r\n", (status < 0) ? "LOSE" : "WIN");
	board_print(&board);

	// Return success.
	return 0;
}
