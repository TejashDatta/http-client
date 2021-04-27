require_relative '../http_request'
require_relative 'constants'

PARAMETERS_STRING = '{ p => 1, z=>abc }'.freeze

describe 'HttpRequest' do
  let(:http_request) { HttpRequest.new(URL, http_method, parameters_string) }
  let(:http_method) { '' }
  let(:parameters_string) { '' }

  shared_examples 'a correct request' do
    it 'has response with status code 200' do
      expect(http_request.send_request.code).to eq('200')
    end
  end

  shared_examples 'a correct http method call' do |method|
    it 'has response with status code 200' do
      expect(http_request.send(method).code).to eq('200')
    end
  end

  describe '#send_request' do
    context 'when get request' do
      let(:http_method) { 'get' }

      context 'without query parameters' do
        it_behaves_like 'a correct request'
      end

      context 'with query parameters' do
        let(:parameters_string) { PARAMETERS_STRING }

        it_behaves_like 'a correct request'
      end
    end

    context 'when post request' do
      let(:http_method) { 'post' }

      context 'without query parameters' do
        it_behaves_like 'a correct request'
      end

      context 'with query parameters' do
        let(:parameters_string) { PARAMETERS_STRING }

        it_behaves_like 'a correct request'
      end
    end

    context 'when unsupported request' do
      let(:http_method) { 'put' }

      it 'raises UnsupportedHttpMethodError' do
        expect { http_request.send_request }.to raise_error(UnsupportedHttpMethodError)
      end
    end
  end

  describe '#parse_parameters_to_hash' do
    it 'parses correctly' do
      expect(http_request.send(:parse_parameters_to_hash, 'a =abc efg, b= 20,c=3')).to eq(
        { 'a' => 'abc efg', 'b' => '20', 'c' => '3' }
      )
    end
  end
  
  describe '#get' do
    context 'when without query parameters' do
      it_behaves_like 'a correct http method call', :get
    end

    context 'when with query parameters' do
      let(:parameters_string) { PARAMETERS_STRING }

      it_behaves_like 'a correct http method call', :get
    end
  end

  describe '#post' do
    context 'when without query parameters' do
      it_behaves_like 'a correct http method call', :post
    end

    context 'when with query parameters' do
      let(:parameters_string) { PARAMETERS_STRING }

      it_behaves_like 'a correct http method call', :post
    end
  end
end
