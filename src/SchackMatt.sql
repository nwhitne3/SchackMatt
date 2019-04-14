CREATE TABLE game_board
	(game_board_id INTEGER NOT NULL PRIMARY KEY,
	 game_id INTEGER NOT NULL
	 		REFERENCES game (game_id),
	 white_player_id INTEGER NOT NULL
	 		REFERENCES player (player_id),
	 black_player_id INTEGER NOT NULL
	 		REFERENCES player (player_id),
	 game_board_slot_id_available BOOLEAN NOT NULL,
	 game_board_out_of_bounds BOOLEAN NOT NULL);

CREATE TABLE valid_moves
	(valid_move_id INTEGER NOT NULL PRIMARY KEY,
	 game_piece_ID INTEGER NOT NULL
	 		REFERENCES game_piece (game_piece_id),
	 game_board_slot_id INTEGER NOT NULL,
	 valid_move_start_pos INTEGER NOT NULL,
	 valid_move_end_pos INTEGER NOT NULL,
	 valid_move_oob_slot BOOLEAN NOT NULL);

CREATE TABLE move
	(move_id INTEGER NOT NULL PRIMARY KEY,
	 game_id INTEGER NOT NULL
	 		REFERENCES game (game_id),
	 player_id INTEGER NOT NULL
	 		REFERENCES player (player_id),
	 game_piece_id INTEGER NOT NULL
	 		REFERENCES game_piece (game_piece_id),
	 move_start_pos INTEGER NOT NULL,
	 move_end_pos INTEGER NOT NULL);

CREATE TABLE game_history
	(game_history_rec_id INTEGER NOT NULL PRIMARY KEY,
	 player_id INTEGER NOT NULL
	 		REFERENCES player (player_id),
	 game_id INTEGER NOT NULL
	 		REFERENCES game (game_id),
	 white_player_id INTEGER NOT NULL
	 		REFERENCES player (player_id),
	 black_player_id INTEGER NOT NULL
	 		REFERENCES player (player_id),
	 valid_move_id INTEGER NOT NULL
	 		REFERENCES move (move_id),
	 winning_player_id INTEGER NOT NULL
	 		REFERENCES player (player_id));


CREATE TABLE game_piece 
	(game_piece_id INTEGER NOT NULL PRIMARY KEY,
	 game_piece_type VARCHAR(255) NOT NULL,
	 game_piece_position INTEGER NOT NULL,
	 game_piece_color BOOLEAN NOT NULL,
	 game_piece_removed BOOLEAN NOT NULL,
	 game_id INTEGER NOT NULL
	 		REFERENCES game( game_id),
	 player_id INTEGER NOT NULL
	 		REFERENCES player( player_id));

CREATE TABLE game
	(game_id INTEGER NOT NULL PRIMARY KEY,
	 game_piece_id INTEGER NOT NULL
	 		REFERENCES game_piece (game_piece_id),
	 white_player_id VARCHAR(255) NOT NULL
	 		REFERENCES player (player_id),
	 black_player_id VARCHAR(255) NOT NULL
	 		REFERENCES player (player_id),
	 player_id_turn_count INTEGER,
	 winning_player_id INTEGER
	 		REFERENCES player (player_id));

CREATE TABLE player
	(player_id INTEGER NOT NULL PRIMARY KEY,
	 move_id INTEGER NOT NULL
	 		REFERENCES move (move_id),
	 valid_move_id INTEGER NOT NULL
	 		REFERENCES valid_move( valid_move_id));