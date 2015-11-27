class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string :cmd
      t.integer :exp_id

      t.timestamps null: false
    end
  end
end
