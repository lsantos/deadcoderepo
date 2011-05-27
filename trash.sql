

select * from baseball_pitching_records where  box_score_id = 5985 and alignment = "home" 
order by sequence

select p.last_name, p.first_name, pr.sequence from baseball_pitching_records pr inner join baseball_players p on pr.player_id = p.id where  box_score_id = 5985 and alignment = "away" 
order by pr.sequence


select * from baseball_box_scores where event_id = 5832



select pr.id, pr.player_id,p.last_name, p.first_name, pr.slot_index, pr.batting_slot, pr.position from baseball_player_records pr inner join baseball_players p on pr.player_id = p.id where pr.box_score_id = 5985 and pr.alignment = "away" 
order by pr.slot_index



select * from baseball_standings where team_id = 14 limit 1


select * from baseball_events where season_id=3 and game_type in("Division Playoff","LCS", "World Series") 
order by game_date

select * from baseball_odds where event_id in(select id from baseball_events where season_id=3 and game_type in("Division Playoff","LCS", "World Series"))


delete from football_box_scores where event_id IN (select id from football_events where game_date = '2010-10-17')
delete from football_play_by_play_records where event_id IN (select id from football_events where game_date = '2010-10-17')
update football_events set status_id =1 where game_date = '2010-10-17'


select * from baseball_leaders where season_id=3 limit 10


select distinct(category) from baseball_leaders order by category


delete from baseball_box_scores where event_id = 4366;
delete from baseball_play_by_play_records where event_id = 4366;
UPDATE baseball_events set status_id =1 WHERE id = 4366;


delete from football_box_scores where event_id = 2125;
delete from football_play_by_play_records where event_id = 2125;
UPDATE football_events set status_id =1 WHERE id = 2125;


delete from football_box_scores where event_id = 2224;
delete from football_play_by_play_records where event_id = 2224;
UPDATE football_events set status_id =1 WHERE id = 2224;




select * from football_box_scores where event_id = 2224;





update baseball_events set season_id = 3 where season_id=2 and game_type= "World Series" 





select * from hockey_standings where season_id = 2 limit 40





select * from hockey_standings where conference="Western"
order by division



delete from hockey_box_scores where event_id = 1458;
delete from hockey_play_by_play_records where event_id = 1458;
UPDATE hockey_events set status_id =1 WHERE id = 1458;


SELECT * FROM `hockey_action_goals` WHERE (`hockey_action_goals`.box_score_id = 1796) ORDER BY period, minute, second asc, minute



SELECT * FROM `hockey_goalie_records` WHERE (`hockey_goalie_records`.box_score_id = 1707)  AND (`hockey_goalie_records`.`alignment` = 'home') 
ORDER BY shots_against




select distinct(injury_status) from hockey_injuries


select * from auto_driver_records






delete from auto_driver_records where event_id = (SELECT id FROM auto_events WHERE DATE(race_date) = '2010-10-24' LIMIT 1);
delete from auto_leader_stints where event_id = (SELECT id FROM auto_events WHERE DATE(race_date) = '2010-10-24' LIMIT 1);
delete from auto_final_events where event_id = (SELECT id FROM auto_events WHERE DATE(race_date) = '2010-10-24' LIMIT 1);
UPDATE auto_events SET minutes = NULL, seconds = NULL, laps_completed = NULL, status_id = 1 WHERE DATE(race_date) = '2010-10-24';




