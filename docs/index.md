# NBA Schedule 2018-19
The Complete NBA Regular Season Schedule for 2018-2019.<br />
[Background information](background) and raw data.

Other versions of the NBA Schedule:
[Basic]({{ site.baseurl }}{% link nba-schedule-2018-2019-basic.md %})
<table>
  <thead>
    <tr>
      <th class="game_date_header">Date</th>
      <th class="game_time_et_header">Time (ET)</th>
      <th class="logos_header">Logos</th>
      <th class="away_team_header">Away Team</th>
      <th class="home_team_header">Home Team</th>
    </tr>
  </thead>
{% for game in site.data.NBA-Full-Schedule-frills-2018-2019 %}
  <tr>
    <td class="game_date g{{ game.game_number_this_day }}">{{ game.game_date }}</td>
    <td class="game_time_et g{{ game.game_number_this_day_and_time }}">{{ game.game_time_et }}</td>
    <td class="logos">
      <img src="https://secure.espn.com/combiner/i?img=/i/teamlogos/nba/500/scoreboard/{{ game.away_team_espn_abbr }}.png&w=100&h=100">
      @
      <img src="https://secure.espn.com/combiner/i?img=/i/teamlogos/nba/500/scoreboard/{{ game.home_team_espn_abbr }}.png&w=100&h=100">
    </td>
    <td class="away_team">{{ game.away_team }}</td>
    <td class="home_team">{{ game.home_team }}</td>
  </tr>
{% endfor %}
</table>