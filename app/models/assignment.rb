class Assignment < ActiveRecord::Base
  include XQueueAdapter
  def next_job
    cookie = Assignment.get_session

    response = get_waiting_number cookie, self.queue_name
    if response['content'].to_i > 0
      response = get_job cookie, self.queue_name
      content = JSON.parse(response['content'])
      job = GraderJob.new(
        :submission_key => content['xqueue_header'],
        :anonym_id => JSON.parse(JSON.parse(content['xqueue_body'])['student_info'])['anonymous_student_id'],
        :grader_payload => JSON.parse(content['xqueue_body'])['grader_payload']
      )
      job.save
      job.grade
    end
    self.next_job
  end
  handle_asynchronously :next_job, :run_at => Proc.new { 1.seconds.from_now }, :priority => 1

  def get_code_file
    self.code_file.split(';')
  end

end
