require_relative '../http_request'
require_relative 'constants'

describe 'HttpRequest' do
  let(:http_request_get) { HttpRequest.new(URL, 'get', '') }
  let(:http_request_get_with_query) { HttpRequest.new(URL, 'get', QUERY_STRING) }
  let(:http_request_post) { HttpRequest.new(URL, 'post', '') }
  let(:http_request_get_with_query) { HttpRequest.new(URL, 'post', QUERY_STRING) }

  describe '#send_request' do
    context 'when get request without query parameters' do
      it 'has response with status code 200' do
        expect(http_request_get.send_request.code).to eq('200')
      end
    end

    context 'when get request with query parameters' do
      it 'has response with status code 200' do
        expect(http_request_get_with_query.send_request.code).to eq('200')
      end
    end

    context 'when post request without post parameters' do
      it 'has response with status code 200' do
        expect(http_request_post.send_request.code).to eq('200')
      end
    end

    context 'when post request with post parameters' do
      it 'has response with status code 200' do
        expect(http_request_get_with_query.send_request.code).to eq('200')
      end
    end

    context 'when unsupported request' do
      it 'raises UnsupportedHttpMethodError' do
        expect { HttpRequest.new(URL, 'put', '').send_request }.to raise_error(
          UnsupportedHttpMethodError
        )
      end
    end
  end

  describe '#parse_parameters_to_hash' do
    it 'parses correctly' do
      expect(http_request_get_with_query.send(:parse_parameters_to_hash, 'a =abc efg, b= 20,c=3')).to eq(
        { 'a' => 'abc efg', 'b' => '20', 'c' => '3' }
      )
    end
  end
  
  describe '#get' do
    context 'when without query parameters' do
      it 'has response with status code 200' do
        expect(http_request_get.send(:get).code).to eq('200')
      end
    end

    context 'when with query parameters' do
      it 'has response with status code 200' do
        expect(http_request_get_with_query.send(:get).code).to eq('200')
      end
    end
  end

  describe '#post' do
    context 'when without query parameters' do
      it 'has response with status code 200' do
        expect(http_request_post.send(:post).code).to eq('200')
      end
    end

    context 'when with query parameters' do
      it 'has response with status code 200' do
        expect(http_request_get_with_query.send(:post).code).to eq('200')
      end
    end
  end
end
