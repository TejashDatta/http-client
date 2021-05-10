require_relative 'http_request'
require_relative 'errors/unsupported_output_type_error'

class HttpClient
  def initialize(url, method, parameters, number_of_threads, number_of_loops, output_type)
    @url = url
    @method = method
    @parameters = parameters
    @number_of_threads = number_of_threads.to_i
    @number_of_loops = number_of_loops.to_i
    @output_type = output_type
    @responses = []
  end

  def run
    send_requests_concurrently_in_loops
    display
  end

  private

  def send_requests_concurrently_in_loops
    @number_of_loops.times do
      threads = []
      @number_of_threads.times do
        threads << Thread.new do
          begin
            @responses << HttpRequest.new(@url, @method, @parameters).send_request
          rescue Net::OpenTimeout, Errno::ECONNRESET
          end
        end
      end
      threads.each(&:join)
    end
  end

  def display
    case @output_type
    when 'response-codes-aggregation'
      display_response_codes_aggregation
    when 'response-bodies'
      display_response_bodies
    else
      raise UnsupportedOutputTypeError
    end
  end

  def display_response_codes_aggregation
    aggregate_response_codes.each { |response_code, count| puts "#{response_code}: #{count}" }
  end

  def aggregate_response_codes
    @responses.each_with_object(Hash.new(0)) do |response, response_codes|
      response_codes[response.code] += 1
    end
  end

  def display_response_bodies
    @responses.each { |response| puts response.body }
  end
end

if __FILE__ == $0
  HttpClient.new(*ARGV[0..5]).run
end
