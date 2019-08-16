# Background
I wanted to download the NBA schedule, and I was surprised to
find that it isn't easily found. The NBA posts a reasonably useful season schedule.
But I wanted the raw data in a format to sort and filter and manipulate as I like.

## Raw data
So first I gathered the raw data. I used that first to make the simplest possible schedule:
[2019-2020 NBA schedule in a table](index).
[2018-2019 NBA schedule in a table](nba-schedule-2018-2019-basic).

Then loaded it into a database.

```
psql -U postgres -d test

create table nba_games (
   dayofweek    text
  ,date_string  text
  ,game_time    text
  ,home_team    text
  ,home_jersey  text
  ,away_team    text
  ,away_jersey  text
  ,arena_name   text
  ,arena_city   text
);

\copy nba_games from 'all_games.tsv'
```

It's useful to have a list of the 30 teams as well.

```
create table nba_teams (
   team       text
  ,name       text
  ,city       text
  ,full_name  text
  ,arena      text
);

\copy nba_teams from 'all_teams.tsv'
```

With the data in PostgreSQL, we can not make some non-trivial queries to enhance the data.


They also have related sites like LockerVision. But that site is unloved and pathetic.
It gets lists arenas incorrectly. Team names are wrong. It's ridiculous.


