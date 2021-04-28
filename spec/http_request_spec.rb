require_relative '../http_request'

describe 'HttpRequest' do
  let(:url) { 'http://0.0.0.0:8080/' }
  let(:http_request) { HttpRequest.new(url, http_method, parameters_string) }
  let(:test_parameters_string) { 'a =abc efg, b= 20,c=3' }

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
        let(:parameters_string) { '' }

        it_behaves_like 'a correct request'
      end

      context 'with query parameters' do
        let(:parameters_string) { test_parameters_string }

        it_behaves_like 'a correct request'
      end
    end

    context 'when post request' do
      let(:http_method) { 'post' }

      context 'without query parameters' do
        let(:parameters_string) { '' }

        it_behaves_like 'a correct request'
      end

      context 'with query parameters' do
        let(:parameters_string) { test_parameters_string }

        it_behaves_like 'a correct request'
      end
    end

    context 'when unsupported request' do
      let(:http_method) { 'put' }
      let(:parameters_string) { '' }

      it 'raises UnsupportedHttpMethodError' do
        expect { http_request.send_request }.to raise_error(UnsupportedHttpMethodError)
      end
    end
  end

  describe '#parse_parameters_to_hash' do
    let(:http_method) { 'get' }
    let(:parameters_string) { test_parameters_string }

    it 'parses correctly' do
      expect(http_request.send(:parse_parameters_to_hash, test_parameters_string)).to eq(
        { 'a' => 'abc efg', 'b' => '20', 'c' => '3' }
      )
    end
  end
  
  describe '#get' do
    let(:http_method) { 'get' }

    context 'when without query parameters' do
      let(:parameters_string) { '' }

      it_behaves_like 'a correct http method call', :get
    end

    context 'when with query parameters' do
      let(:parameters_string) { test_parameters_string }

      it_behaves_like 'a correct http method call', :get
    end
  end

  describe '#post' do
    let(:http_method) { 'post' }

    context 'when without query parameters' do
      let(:parameters_string) { '' }

      it_behaves_like 'a correct http method call', :post
    end

    context 'when with query parameters' do
      let(:parameters_string) { test_parameters_string }

      it_behaves_like 'a correct http method call', :post
    end
  end
end
