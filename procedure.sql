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