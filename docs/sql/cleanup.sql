/* SQL used to cleanup some of the raw data */

update "NBA-Full-Schedule-no-frills-2020-2021" t
set t.away_team = subquery.at_code, t.home_team = subquery.ht_code
from (
  select game_id, at.code as at_code, ht.code as ht_code from "NBA-Full-Schedule-no-frills-2020-2021" g
  left outer join nba_teams at on ( at.fullname = g.away_team_full_name )
  left outer join nba_teams ht on ( ht.fullname = g.home_team_full_name )
) as subquery
where t.game_id = subquery.game_id
;


create table "NBA-Full-Schedule-frills-2020-2021" as
select 
    s.game_id
  , 'https://www.nba.com/game/' || lower(away_team) || '-vs-' || lower(home_team) || '-002200' || lpad(s.game_id, 4, '0')  as game_url
  , tv
  , game_date 
  , game_time_et 
  , away_team
  , home_team 
  , away_team_full_name 
  , home_team_full_name
  , rank() over (partition by game_date order by game_id_int) as game_number_this_day
  , rank() over (partition by game_date, game_time_et order by game_id_int) as game_number_this_day_and_time
  , s.arena 
  , s.city
  , a.espn_abbr as away_team_espn_abbr
  , h.espn_abbr as home_team_espn_abbr
from public."NBA-Full-Schedule-no-frills-2020-2021" s
join links_to_games_nba l on ( l.url = 'https://www.nba.com/game/' || lower(away_team) || '-vs-' || lower(home_team) || '-002200' || lpad(s.game_id, 4, '0') )
join nba_teams a on ( a.code = s.away_team )
join nba_teams h on ( h.code = s.home_team )
order by s.game_id::int 
;


/* Export to Excel/CSV */
select * from "NBA-Full-Schedule-frills-2020-2021"
order by game_date, regexp_replace(substring(game_time_et, 1, 5) , '[^[:digit:]]', '')::int, game_number_this_day, game_number_this_day_and_time 

