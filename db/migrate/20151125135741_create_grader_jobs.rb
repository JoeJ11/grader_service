class CreateGraderJobs < ActiveRecord::Migration
  def change
    create_table :grader_jobs do |t|
      t.string :anonym_id
      t.string :submission_key
      t.text :grader_payload

      t.timestamps null: false
    end
  end
end
