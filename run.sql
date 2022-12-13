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
SELECT * FROM players;


CREATE OR REPLACE PROCEDURE set_date_and_goals(matches_played INT, num_of_goals INT, num_of_assists INT, num_of_yellow INT,
											   num_of_red INT, date_to_set DATE)
LANGUAGE plpgsql
AS $$
	DECLARE stats_id INT;
	BEGIN
		ALTER TABLE stats ADD COLUMN IF NOT EXISTS date_of_record DATE;
		INSERT INTO players(player_name, player_position, team_id) VALUES('Bob', 'Forward', 3); 
		SELECT player_id INTO stats_id FROM players ORDER BY player_id DESC LIMIT 1;
		INSERT INTO stats(player_id, matches_played, goals, assists, yellow_cards, red_cards, date_of_record)
		VALUES(stats_id, matches_played, num_of_goals, num_of_assists, num_of_yellow, num_of_red, date_to_set);
    
END
$$

CALL set_date_and_goals(10, 10, 0, 2, 0, '2021-12-15');
SELECT * FROM stats;

DROP TABLE IF EXISTS changes;
CREATE TABLE changes(
	id SERIAL PRIMARY KEY,
	old_team_id INT NOT NULL,
	new_team_id INT NOT NULL,
	updated TIMESTAMP
);

CREATE OR REPLACE FUNCTION players_update() 
RETURNS trigger 
LANGUAGE plpgsql 
AS
	$$
	BEGIN
		IF NEW.team_id <> OLD.team_id THEN
			INSERT INTO changes(old_team_id, new_team_id, updated)
			VALUES(OLD.team_id, NEW.team_id, NOW());
		END IF;
		RETURN NEW;
	END;
	$$ 

DROP TRIGGER IF EXISTS show_update ON players;
CREATE TRIGGER show_update
BEFORE UPDATE ON players
FOR EACH ROW EXECUTE FUNCTION players_update();

UPDATE players SET team_id = 3 WHERE player_name = 'Karim Benzema';


SELECT * FROM changes;


DELETE FROM stats
WHERE player_id > 10;

DELETE FROM players
WHERE player_id > 10;
