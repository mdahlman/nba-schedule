# Background
I wanted to download the NBA schedule for 2018-2019, and I was surprised to
find that it isn't easily found. The NBA posts a reasonably useful season schedule.
But I wanted the raw data in a format to sort and filter and manipulate as I like.

## Raw data
So first I gathered the raw data. I used that first to make the simplest possible schedule.
Here's the [2018-2019 NBA schedule in a table](index).

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


They also have related sites like LockerVision. But that site doesn't get details 
like the arena correct. It still shows the Bucks at the BMO Harris Bradley Center.
And it can't even get team names quite right. It lists the Los Angeles Clippers when
all other NBA sites refer to the LA Clippers.


