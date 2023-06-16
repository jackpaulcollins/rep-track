module LeaderboardHelper
  def leaderboard_badge(index)
    case index
    when 0
      "🥇"
    when 1
      "🥈"
    when 2
      "🥉"
    else
      ""
    end
  end
end
