class ChangePublicColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :challenges, :public, :is_public_challenge
  end
end
