CREATE TABLE game_board
	(game_board_id INTEGER NOT NULL PRIMARY KEY,
	 game_id INTEGER NOT NULL
	 		REFERENCES game (game_id),
	 white_player_id INTEGER NOT NULL
	 		REFERENCES player (player_id),
	 black_player_id INTEGER NOT NULL
	 		REFERENCES player (player_id),
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
	(game_piece_id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
	 game_piece_type VARCHAR(255) NOT NULL,
	 game_piece_position INTEGER NOT NULL,
	 game_piece_color BOOLEAN NOT NULL,
	 game_piece_removed BOOLEAN NOT NULL ,
	 game_id INTEGER NOT NULL
	 		REFERENCES game( game_id));

CREATE TABLE game
	(game_id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
	 game_piece_id INTEGER,
	 white_player_id INTEGER NOT NULL
	 		REFERENCES player (player_id),
	 black_player_id INTEGER NOT NULL
	 		REFERENCES player (player_id),
	 player_id_turn_count INTEGER,
	 winning_player_id INTEGER
	 		REFERENCES player (player_id));

CREATE TABLE player
	(player_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	 player_name VARCHAR(10),
	 move_id INTEGER
	 		REFERENCES move (move_id),
	 valid_move_id INTEGER
	 		REFERENCES valid_move( valid_move_id));


CREATE TABLE out_of_bounds_move
	(oob_space INTEGER NOT NULL);


DELIMITER $$
CREATE PROCEDURE new_player (IN play_name VARCHAR(10))
BEGIN
INSERT INTO player(player_name) value (play_name);
END
$$

DELIMITER ??
CREATE PROCEDURE new_game (IN w_play_name VARCHAR(10),
                           IN b_play_name VARCHAR(10))
BEGIN
INSERT INTO game (white_player_id, black_player_id) VALUES(
	 (SELECT player.player_id FROM player WHERE player.player_name LIKE w_play_name),

  (SELECT player.player_id FROM player WHERE player.player_name LIKE b_play_name));
END ??

DELIMITER &&
CREATE PROCEDURE move_piece (
@player VARCHAR(10),
@game   INTEGER,
@piece  VARCHAR(10),
@end_pos INTEGER)
BEGIN
        IF @piece = "Pawn" AND

                (
                    (move_end_pos <> (game_piece.game_piece_position + 10))
                    OR
                    (move_end_pos <> (game_piece.game_piece_position + 9)
                     AND
                        (SELECT * FROM game_piece
                          WHERE(game_id IN
                                (SELECT  MAX(ID) FROM game)
                          AND game_piece_color = 0
                          AND game_piece_position = move_end_pos
                          AND game_piece_removed = 0)
                          NOT NULL))
                    OR
                    (move_end_pos <> (game_piece.game_piece_position + 11))
                )

            OR
            (game_piece_color = 1
            AND
                ( move_end_pos <> (game_piece.game_piece_position - 10))
                OR
                (move_end_pos <> (game_piece.game_piece_position - 9)
                AND
                (SELECT * FROM game_piece
                    WHERE game_id IN
                        (SELECT  MAX(ID) FROM game)
                    AND game_piece_color = 0
                    AND game_piece_position = move_end_pos
                    AND game_piece_removed = 0)
                    NOT NULL))
                OR
                (move_end_pos <> (game_piece.game_piece_position - 11))
        THEN
            CALL `'Invalid move'`;
        END IF;
END &&


-- CREATE TABLE game_piece
--	(game_piece_id INTEGER NOT NULL PRIMARY KEY,
--	 game_piece_type VARCHAR(255) NOT NULL,
--	 game_piece_position INTEGER NOT NULL,
--	 game_piece_color BOOLEAN NOT NULL,
--	 game_piece_removed BOOLEAN,
--	 game_id INTEGER NOT NULL
--	 		REFERENCES game( game_id));





CREATE TRIGGER trg_on_new_game AFTER INSERT ON game
FOR EACH ROW INSERT INTO game_piece(game_piece_type, game_piece_position, game_piece_color, game_piece_removed, game_id) VALUES
("pawn1", 31, 1, 0, (SELECT MAX(game_id) FROM game)),
("pawn2", 32, 1, 0, (SELECT MAX(game_id) FROM game)),
("pawn3", 33, 1, 0, (SELECT MAX(game_id) FROM game)),
("pawn4", 34, 1, 0, (SELECT MAX(game_id) FROM game)),
("pawn5", 35, 1, 0, (SELECT MAX(game_id) FROM game)),
("pawn6", 36, 1, 0, (SELECT MAX(game_id) FROM game)),
("pawn7", 37, 1, 0, (SELECT MAX(game_id) FROM game)),
("pawn8", 38, 1, 0, (SELECT MAX(game_id) FROM game)),
("pawn9", 81, 0, 0, (SELECT MAX(game_id) FROM game)),
("pawn10", 82, 0, 0, (SELECT MAX(game_id) FROM game)),
("pawn11", 83, 0, 0, (SELECT MAX(game_id) FROM game)),
("pawn12", 84, 0, 0, (SELECT MAX(game_id) FROM game)),
("pawn13", 85, 0, 0, (SELECT MAX(game_id) FROM game)),
("pawn14", 86, 0, 0, (SELECT MAX(game_id) FROM game)),
("pawn15", 87, 0, 0, (SELECT MAX(game_id) FROM game)),
("pawn16", 89, 0, 0, (SELECT MAX(game_id) FROM game)),
("knight1", 22, 1, 0, (SELECT MAX(game_id) FROM game)),
("knight2", 27, 1, 0, (SELECT MAX(game_id) FROM game)),
("knight3", 92, 0, 0, (SELECT MAX(game_id) FROM game)),
("knight4", 97, 0, 0, (SELECT MAX(game_id) FROM game)),
("rook1", 21, 1, 0, (SELECT MAX(game_id) FROM game)),
("rook2", 91, 0, 0, (SELECT MAX(game_id) FROM game)),
("rook3", 28, 1, 0, (SELECT MAX(game_id) FROM game)),
("rook4", 98, 0, 0, (SELECT MAX(game_id) FROM game)),
("bishop1", 23, 1, 0, (SELECT MAX(game_id) FROM game)),
("bishop2", 93, 0, 0, (SELECT MAX(game_id) FROM game)),
("bishop3", 26, 1, 0, (SELECT MAX(game_id) FROM game)),
("bishop4", 96, 0, 0, (SELECT MAX(game_id) FROM game)),
("queen1", 25, 1, 0, (SELECT MAX(game_id) FROM game)),
("queen2", 94, 0, 0, (SELECT MAX(game_id) FROM game)),
("king1", 24, 1, 0, (SELECT MAX(game_id) FROM game)),
("king2", 95, 0, 0, (SELECT MAX(game_id) FROM game));
