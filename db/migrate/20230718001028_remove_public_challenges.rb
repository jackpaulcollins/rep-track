class RemovePublicChallenges < ActiveRecord::Migration[7.0]
  def change
    remove_column :challenges, :is_public_challenge
  end
end
