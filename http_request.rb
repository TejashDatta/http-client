require 'net/http'

class HttpRequest
  def initialize(url, method, parameters_string)
    @uri = URI(url)
    @method = method
    @parameters = parse_parameters_to_hash(parameters_string)
  end

  def send
    case @method
    when 'get' then get
    when 'post' then post
    else raise UnsupportedHttpMethod
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
    parameters = {}
    parameters_string.split(',').each do |key_value_pair|
      key, value = key_value_pair.split('=').map(&:strip)
      parameters[key] = value
    end
    parameters
  end
end

class UnsupportedHttpMethod < StandardError
end
