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