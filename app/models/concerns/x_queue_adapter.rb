module XQueueAdapter

  USER_NAME = 'tsinghua'
  PASSWORD = '513WLQL5YIMJO7R8EZB3ZUXXSHBI9H5F'
  BASE_URL = 'http://xqueue.xuetangx.com'

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def get_session
      response = HTTParty.post(
        BASE_URL + '/xqueue/login/',
        :body => {
          'username' => USER_NAME,
          'password' => PASSWORD
        }
      )
      Rails.logger.info "XQueue Server Response (get session): #{response}"
      response.header['set-cookie']
    end
  end

  def get_waiting_number(cookie, queue_name)
    response = HTTParty.get(
      BASE_URL + "/xqueue/get_queuelen?queue_name=#{queue_name}",
      :headers => {
        'cookie' => cookie
      }
    )
    Rails.logger.info "XQueue Server Response (get_waiting_number): #{response}"
    JSON.parse(response.parsed_response)
  end

  def get_job(cookie, queue_name)
    response = HTTParty.get(
      BASE_URL + "/xqueue/get_submission?queue_name=#{queue_name}",
      :headers => {
        'cookie' => cookie
      }
    )
    Rails.logger.info "XQueue Server Response (get_job): #{response}"
    JSON.parse(response.parsed_response)
  end

  def return_result(cookie, queue_header, result)
    puts queue_header
    response = HTTParty.post(
      BASE_URL + '/xqueue/put_result/',
      :headers => {
        'cookie' => cookie
      },
      :body => {
        'xqueue_header' => queue_header,
        'xqueue_body' => JSON.generate(result)
      }
    )
    Rails.logger.info "XQueue Server Response (return_result): #{response}"
    JSON.parse(response.parsed_response)
  end

end
