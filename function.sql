CREATE OR REPLACE FUNCTION count_pos(pos CHAR(20))
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE num_of_positions INT;
BEGIN
		SELECT COUNT(players.player_position) INTO num_of_positions FROM players
		WHERE players.player_position = pos;
		RETURN num_of_positions;
END; 
$$ 


SELECT count_pos('Forward');