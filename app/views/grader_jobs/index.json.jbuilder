json.array!(@grader_jobs) do |grader_job|
  json.extract! grader_job, :id, :anonym_id, :submission_key, :grader_payload
  json.url grader_job_url(grader_job, format: :json)
end
