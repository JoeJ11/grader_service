class GraderJob < ActiveRecord::Base
  include XQueueAdapter

  MAIN_SERVER_URL = 'http://218.247.230.201/dispatches/file?'

  def grading
    @cookie = GraderJob.get_session
    payload = JSON.parse(self.grader_payload)
    exp = Assignment.find_by_exp_id payload['exp_id']
    file_content = _get_file(self.anonym_id, payload['exp_id'], payload['file_path'])
    unless file_content
      _generate_error_response '<p> Remote file not found. </p>'
      return
    end
    # Rails.logger.info "FILE_CONTENT:#{file_content}"
    response = nil
    Dir.mktmpdir do |dir|
      File.open(dir+'/answer', 'w') do |f|
        f.write(file_content)
      end
      # File.open(dir+'/answer', 'r:UTF-8') do |f|
      #   puts f.read
      # end
      Rails.logger.info("GRADER::CMD: #{exp.cmd} #{dir}")
      Open4::popen4('sh') do |pid, stdin, stdout, stderr|
        stdin.puts("cd #{Rails.root.join('grader')}")
        stdin.puts("#{exp.cmd} #{dir}")
        stdin.close

        Rails.logger.info "GRADER::STDOUT: #{stdout.read.strip}"
        Rails.logger.info "GRADER::STDERR: #{stderr.read.strip}"
      end
      File.open(dir+'/response', 'r') do |f|
        response = f.read.split("\n")
      end
    end
    _return_result(response)
    self.code_file = ''
    exp.get_code_file.each do |f_name|
      self.code_file += f_name + _get_file(self.anonym_id, payload['exp_id'], f_name) + "\n\n"
    end
    self.save
  end
  handle_asynchronously :grading, :priority => 2

  def _get_file(user_name, exp_id, file_path)
    response = HTTParty.get(
      MAIN_SERVER_URL + "anonym_id=#{user_name}&exp_id=#{exp_id}&file_path=#{file_path}"
    )
    Rails.logger.info "Get File::#{response['found']}"
    if response['found'] == 'True'
      return Base64.decode64(response['content']).force_encoding('UTF-8')
    else
      return nil
    end
  end

  def _generate_error_response msg
    body = {
      'correct' => false,
      'score' => 0,
      'msg' => "<p>Internal Error!</p>\n" + msg
    }
    self.grade = -1
    self.code_file = msg
    self.save
    return_result @cookie, self.submission_key, body
  end

  def _return_result(response)
    if response
      body = {
          'correct' => response[0] == response[1],
          'score' => response[0].to_i,
      }
      self.grade = response[0].to_i
      if response.size > 2
        body['msg'] = response[2..-1].join("\n")
      else
        body['msg'] = '<p>No comment.</p>'
      end
      Rails.logger.info "RESPONSE::CORRECTNESS:#{body['correct']}"
      Rails.logger.info "RESPONSE::SCORE:#{body['score']}"
      Rails.logger.info "RESPONSE::MSG:#{body['msg']}"
      return_result @cookie, self.submission_key, body
    else
      _generate_error_response '<p>Response file not found.</p>'
    end
  end
end
