# NBA Schedule 2018-19
[Home]({{ site.baseurl }}{% link index.md %})

This is the most boring no-frills table possible. I love it.

<table>
  <thead>
    <tr>
      <th class="game_date_header">Date</th>
      <th class="game_time_et_header">Time (ET)</th>
      <th class="away_team_header">Away Team</th>
      <th class="home_team_header">Home Team</th>
    </tr>
  </thead>
{% for game in site.data.NBA-Full-Schedule-no-frills-2018-2019 %}
  <tr>
    <td class="game_date">{{ game.game_date }}</td>
    <td class="game_time_et">{{ game.game_time_et }}</td>
    <td class="away_team">{{ game.away_team }}</td>
    <td class="home_team">{{ game.home_team }}</td>
  </tr>
{% endfor %}
</table>