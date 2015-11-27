class AddSettingToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :queue_name, :string
  end
end
