class AddChallengeToReport < ActiveRecord::Migration[7.0]
  def change
    add_reference :reports, :challenge, foreign_key: true, index: true
  end
end
