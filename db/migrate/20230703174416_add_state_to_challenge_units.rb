class AddStateToChallengeUnits < ActiveRecord::Migration[7.0]
  def change
    add_column :challenge_units, :state, :string
  end
end
