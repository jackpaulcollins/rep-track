class DefaultForPublicChallenges < ActiveRecord::Migration[7.0]
  def change
    change_column_default :challenges, :is_public_challenge, false
  end
end
