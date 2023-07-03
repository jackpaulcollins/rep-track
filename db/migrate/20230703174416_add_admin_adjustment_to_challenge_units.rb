class AddAdminAdjustmentToChallengeUnits < ActiveRecord::Migration[7.0]
  def change
    add_column :challenge_units, :is_admin_adjustment, :boolean, default: false
  end
end
