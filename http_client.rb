require_relative 'http_request'
require_relative 'errors/unsupported_output_type_error'

class HttpClient
  def initialize(url, method, parameters, number_of_threads, number_of_loops)
    @url = url
    @method = method
    @parameters = parameters
    @number_of_threads = number_of_threads.to_i
    @number_of_loops = number_of_loops.to_i
  end

  def run(output_type)
    case output_type
    when 'response-codes-aggregation'
      display_response_codes_aggregation
    when 'response-bodies'
      display_response_bodies
    else
      raise UnsupportedOutputTypeError
    end
  end

  def display_response_codes_aggregation
    response_codes = Hash.new(0)
    response_codes_semaphore = Mutex.new

    send_requests_in_concurrent_loops do |response|
      response_codes_semaphore.synchronize { response_codes[response.code] += 1 }
    end

    response_codes.each { |code, count| puts "#{code}: #{count}" }
  end

  def display_response_bodies
    send_requests_in_concurrent_loops { |response| puts response.body }
  end

  private

  def send_requests_in_concurrent_loops
    threads = []
    @number_of_threads.times do
      threads << Thread.new do
        @number_of_loops.times do
          yield HttpRequest.new(@url, @method, @parameters).send_request
        end
      end
    end
    threads.each(&:join)
  end
end

if __FILE__ == $0
  HttpClient.new(*ARGV[0..4]).run(ARGV[5])
end
