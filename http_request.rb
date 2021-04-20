require 'net/http'
require_relative 'errors/unsupported_http_method_error'

class HttpRequest
  def initialize(url, method, parameters_string)
    @uri = URI(url)
    @method = method
    @parameters = parse_parameters_to_hash(parameters_string)
  end

  def send_request
    case @method
    when 'get' then get
    when 'post' then post
    else raise UnsupportedHttpMethodError
    end
  end

  private

  def get
    @uri.query = URI.encode_www_form(@parameters)
    Net::HTTP.get_response(@uri)
  end

  def post
    Net::HTTP.post_form(@uri, @parameters)
  end

  def parse_parameters_to_hash(parameters_string)
    parameters_string.split(',')
                     .map { |key_value_pair| key_value_pair.split('=').map(&:strip) }
                     .to_h
  end
end
