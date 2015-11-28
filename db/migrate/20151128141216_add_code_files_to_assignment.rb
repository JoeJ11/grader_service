class AddCodeFilesToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :code_files, :string
  end
end
