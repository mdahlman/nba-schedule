/* SQL used to cleanup some of the raw data */

/* Import raw data which includes only:
 * row_num, Day, Time, Tournament_Comment, Away, Home, Link
 * (This exact list can change year to year depending on the details of how I got the data.)
 */

/*
 * Games are correctly [chronologically] ordered using row_now.
 * But only the first game each day has the date field populated.
 */

/* This query gets the latest non-null date for each game. */
with cte as (
    select t1.row_num, t1.the_date as the_date, t2.the_date as the_previous_dates /* Actually, previous or equal */
    from nba_temp_2023_2024 t1
    left outer join nba_temp_2023_2024 t2 on t1.row_num::int >= t2.row_num::int
)
select row_num, max(the_previous_dates) as the_previous_date
from cte
group by row_num
order by cte.row_num::int
;

update nba_temp_2023_2024
set the_date = (
    select the_previous_date from (
        with cte as (
            select t1.row_num, t1.the_date as the_date, t2.the_date as the_previous_dates /* Actually, previous or equal */
            from nba_temp_2023_2024 t1
            left outer join nba_temp_2023_2024 t2 on t1.row_num::int >= t2.row_num::int
        )
        select row_num, max(the_previous_dates) as the_previous_date
        from cte
        group by row_num
    ) s
    where s.row_num = nba_temp_2023_2024.row_num
) ;

create table "NBA-Full-Schedule-no-frills-2023-2024" as select * from "NBA-Full-Schedule-no-frills-2020-2021" where 1=0 ;
/* But new this season, there are games without IDs. So we need the row_num which is the order that games appear on NBA.com.
 * Before the season starts, many playoff games are indistinguishable. But they still capture the fact that on one day there
 * will be 2 games and on another day there will be 11 games.
 */
ALTER TABLE public."NBA-Full-Schedule-no-frills-2023-2024" ADD row_num int NULL;
/* This time I retrieved the url directly from the source. */
ALTER TABLE public."NBA-Full-Schedule-no-frills-2023-2024" ADD preview_url text NULL;


--truncate table "NBA-Full-Schedule-no-frills-2023-2024" ;
INSERT INTO "NBA-Full-Schedule-no-frills-2023-2024"
(row_num, game_id, preview_url, game_date, game_time_et, tv, away_team, home_team, away_team_full_name, home_team_full_name, arena, city, game_id_int)
select
    row_num::int
    , coalesce( substring(preview_url, length(preview_url)-9), 'NA' ) as game_id
    , preview_url
    , the_date
    , the_time
    , NULL 
    , NULL 
    , NULL 
    , away_team
    , home_team
    , NULL
    , NULL 
    , substring(preview_url, length(preview_url)-9)::int as game_id_int
from public.nba_temp_2023_2024
order by row_num::int
;


update "NBA-Full-Schedule-no-frills-2023-2024"
set away_team = subquery.at_code, home_team = subquery.ht_code
from (
  select game_id, at.code as at_code, ht.code as ht_code from "NBA-Full-Schedule-no-frills-2023-2024" g
  left outer join nba_teams at on ( at.fullname = g.away_team_full_name )
  left outer join nba_teams ht on ( ht.fullname = g.home_team_full_name )
) as subquery
where "NBA-Full-Schedule-no-frills-2023-2024".game_id = subquery.game_id
;


-- drop table "NBA-Full-Schedule-frills-2023-2024" ;
create table "NBA-Full-Schedule-frills-2023-2024" as
select 
    row_num
  , s.game_id
  , preview_url as game_url
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
from public."NBA-Full-Schedule-no-frills-2023-2024" s
--join links_to_games_nba l on ( l.url = 'https://www.nba.com/game/' || lower(away_team) || '-vs-' || lower(home_team) || '-002200' || lpad(s.game_id, 4, '0') )
left outer join nba_teams a on ( a.code = s.away_team )
left outer join nba_teams h on ( h.code = s.home_team )
order by s.row_num
;


/* Export to Excel/CSV */
select * from "NBA-Full-Schedule-frills-2023-2024"
order by row_num ; 


