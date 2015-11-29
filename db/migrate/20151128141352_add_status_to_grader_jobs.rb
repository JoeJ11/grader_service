class AddStatusToGraderJobs < ActiveRecord::Migration
  def change
    add_column :grader_jobs, :grade, :integer
    add_column :grader_jobs, :code_file, :text
  end
end
