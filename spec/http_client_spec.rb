require_relative '../http_client'
require_relative 'constants'

HTML_RESPONSE_BODY = "<html><body><h1>It works!</h1></body></html>\n".freeze
NUMBER_OF_THREADS = 10
NUMBER_OF_LOOPS = 10
output_count = NUMBER_OF_THREADS * NUMBER_OF_LOOPS

describe 'HttpClient' do
  let(:http_client) {
    HttpClient.new(URL, '', QUERY_STRING, NUMBER_OF_THREADS, NUMBER_OF_LOOPS, '')
  }

  describe '#run' do
    context 'when method is get and output_type is response-bodies' do
      before do 
        http_client.instance_variable_set(:@method, 'get')
        http_client.instance_variable_set(:@output_type, 'response-bodies')
      end

      it 'displays all response-bodies' do
        expect { http_client.run }.to output(HTML_RESPONSE_BODY * output_count).to_stdout
      end
    end

    context 'when method is post and output_type is response-codes-aggregation' do
      before do
        http_client.instance_variable_set(:@method, 'post')
        http_client.instance_variable_set(:@output_type, 'response-codes-aggregation')
      end

      it 'displays response codes aggregation for all codes 200' do
        expect { http_client.run }.to output("200: #{output_count}\n").to_stdout
      end
    end
  end

  shared_context 'http_client has received get responses' do
    before do
      http_client.instance_variable_set(:@method, 'get')
      http_client.send(:send_requests_concurrently_in_loops)
    end
  end

  describe '#send_requests_concurrently_in_loops' do
    include_context 'http_client has received get responses'

    it 'has received all responses' do
      expect(http_client.instance_variable_get(:@responses).count).to eq(output_count)
    end
  end

  describe '#display' do
    include_context 'http_client has received get responses'

    context 'when output_type is response-codes-aggregation' do
      before { http_client.instance_variable_set(:@output_type, 'response-codes-aggregation') }

      it 'displays response code aggregation for all codes 200' do
        expect { http_client.send(:display) }.to output("200: #{output_count}\n").to_stdout
      end
    end
    
    context 'when output_type is response-bodies' do
      before { http_client.instance_variable_set(:@output_type, 'response-bodies') }

      it 'displays response bodies' do
        expect { http_client.send(:display) }.to output(HTML_RESPONSE_BODY * output_count).to_stdout
      end
    end

    context 'when output_type is other' do
      before { http_client.instance_variable_set(:@output_type, 'other') }
      
      it 'raises UnsupportedOutputTypeError' do
        expect { http_client.send(:display) }.to raise_error(UnsupportedOutputTypeError)
      end
    end
  end

  describe '#aggregate_response_codes' do
    include_context 'http_client has received get responses'
    
    it 'aggregates response codes that are all 200' do
      expect(http_client.send(:aggregate_response_codes)).to eq({ '200' => output_count })
    end
  end
end
