require_relative 'http_request'
require_relative 'errors/unsupported_output_type_error'

class HttpClient
  def initialize(url, method, parameters, number_of_threads, number_of_loops)
    @url = url
    @method = method
    @parameters = parameters
    @number_of_threads = number_of_threads.to_i
    @number_of_loops = number_of_loops.to_i
    @response_codes = Hash.new(0)
    @response_bodies = []
  end

  def run(output_type)
    send_requests_concurrently_in_loops

    case output_type
    when 'response-codes-aggregation'
      display_response_codes_aggregation
    when 'response-bodies'
      display_response_bodies
    else
      raise UnsupportedOutputTypeError
    end
  end

  private

  def display_response_codes_aggregation
    @response_codes.each { |response_code, count| puts "#{response_code}: #{count}" }
  end

  def display_response_bodies
    @response_bodies.each { |response_body| puts response_body }
  end

  def send_requests_concurrently_in_loops
    save_response_semaphore = Mutex.new

    @number_of_loops.times do
      threads = []
      @number_of_threads.times do
        threads << Thread.new do
          response = HttpRequest.new(@url, @method, @parameters).send_request
          save_response_semaphore.synchronize { save_response_code_and_body(response) }
        end
      end
      threads.each(&:join)
    end
  end

  def save_response_code_and_body(response)
    @response_bodies << response.body
    @response_codes[response.code] += 1
  end
end

if __FILE__ == $0
  HttpClient.new(*ARGV[0..4]).run(ARGV[5])
end
