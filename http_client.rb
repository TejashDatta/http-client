require_relative 'http_request'

class HttpClient
  def initialize(url, method, parameters, no_of_threads, no_of_loops)
    @url = url
    @method = method
    @parameters = parameters
    @no_of_threads = no_of_threads.to_i
    @no_of_loops = no_of_loops.to_i
    @response_codes = Hash.new(0)
    @response_bodies = []
  end

  def send_requests
    @no_of_loops.times do
      threads = []
      @no_of_threads.times do
        threads << Thread.new { send_request_and_record_response }
        threads.each(&:join)
      end
    end
  end

  def show_responses
    puts 'Response codes: '
    @response_codes.each { |code, count| print "#{code}: #{count} \t" }
    puts "\nResponse bodies: "
    @response_bodies.each { |body| puts body }
  end

  private

  def send_request_and_record_response
    response = HttpRequest.new(@url, @method, @parameters).send
    @response_codes[response.code] += 1
    @response_bodies << response.body
  end
end

if __FILE__ == $0
  http_client = HttpClient.new(*ARGV)
  http_client.send_requests
  http_client.show_responses
end
