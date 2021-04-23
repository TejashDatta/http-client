require_relative '../http_client'
require_relative 'constants'

HTML_RESPONSE_BODY = "<html><body><h1>It works!</h1></body></html>\n".freeze
NUMBER_OF_THREADS = 10
NUMBER_OF_LOOPS = 100
output_count = NUMBER_OF_THREADS * NUMBER_OF_LOOPS

describe 'HttpClient' do
  describe '#run' do
    context 'when method is get and output_type is response-bodies' do
      it 'displays all response-bodies' do
        expect {
          HttpClient
            .new(URL, 'get', QUERY_STRING, NUMBER_OF_THREADS, NUMBER_OF_LOOPS, 'response-bodies')
            .run
        }.to output(HTML_RESPONSE_BODY * output_count).to_stdout
      end
    end

    context 'when method is post and output_type is response-codes-aggregation' do
      it 'displays response code aggregation for all codes 200' do
        expect {
          HttpClient
            .new(URL, 'post', QUERY_STRING, NUMBER_OF_THREADS, NUMBER_OF_LOOPS, 'response-codes-aggregation')
            .run 
        }.to output("200: #{output_count}\n").to_stdout
      end
    end
  end

  describe '#send_requests_concurrently_in_loops' do
    let(:http_client) {
      HttpClient.new(URL, 'get', QUERY_STRING, NUMBER_OF_THREADS, NUMBER_OF_LOOPS, 'response-bodies') 
    }
    before { http_client.send(:send_requests_concurrently_in_loops) }
    
    it 'receives all responses' do
      expect(http_client.instance_variable_get(:@responses).count).to eq(output_count)
    end
  end

  describe '#display' do
    context 'when output_type is response-codes-aggregation' do
      let(:http_client) { 
        HttpClient
          .new(URL, 'get', QUERY_STRING, NUMBER_OF_THREADS, NUMBER_OF_LOOPS, 'response-codes-aggregation') 
      }
      before { http_client.send(:send_requests_concurrently_in_loops) }

      it 'displays response code aggregation for all codes 200' do
        expect { http_client.send(:display) }.to output("200: #{output_count}\n").to_stdout
      end
    end
    
    context 'when output_type is response-bodies' do
      let(:http_client) { 
        HttpClient
          .new(URL, 'get', QUERY_STRING, NUMBER_OF_THREADS, NUMBER_OF_LOOPS, 'response-bodies') 
      }
      before { http_client.send(:send_requests_concurrently_in_loops) }

      it 'displays response bodies' do
        expect { http_client.send(:display) }.to output(HTML_RESPONSE_BODY * output_count).to_stdout
      end
    end

    context 'when output_type is other' do
      it 'raises UnsupportedOutputTypeError' do
        expect { 
          HttpClient
            .new(URL, 'get', QUERY_STRING, NUMBER_OF_THREADS, NUMBER_OF_LOOPS, 'other')
            .send(:display) 
        }.to raise_error(UnsupportedOutputTypeError)
      end
    end
  end

  describe '#aggregate_response_codes' do
    let(:http_client) { 
      HttpClient
        .new(URL, 'get', QUERY_STRING, NUMBER_OF_THREADS, NUMBER_OF_LOOPS, 'response-codes-aggregation') 
    }
    before { http_client.send(:send_requests_concurrently_in_loops) }

    it 'aggregates response codes that are all 200' do
      expect(http_client.send(:aggregate_response_codes)).to eq({ '200' => output_count })
    end
  end
end
