require_relative '../http_client'
require_relative 'constants'

describe 'HttpClient' do
  describe '#run' do
    context 'when single thread is running single loop' do
      let(:http_client) { HttpClient.new(URL, 'get', QUERY_STRING, 1, 1) }
      
      context 'when output_type is response-bodies' do
        it 'displays response body' do
          expect { http_client.run('response-bodies') }.to output(
            "<html><body><h1>It works!</h1></body></html>\n"
          ).to_stdout
        end
      end

      context 'when output_type is response-codes-aggregation' do
        it 'displays response code 200' do
          expect { http_client.run('response-codes-aggregation') }.to output("200: 1\n").to_stdout
        end
      end

      context 'when output_type is other' do
        it 'raises UnsupportedOutputTypeError' do
          expect { http_client.run('other') }.to raise_error(UnsupportedOutputTypeError)
        end
      end
    end

    context 'when multiple threads are running multiple loops' do
      NUMBER_OF_THREADS = 10
      NUMBER_OF_LOOPS = 100
      output_count = NUMBER_OF_THREADS * NUMBER_OF_LOOPS

      let(:http_client) { HttpClient.new(URL, 'get', QUERY_STRING, NUMBER_OF_THREADS, NUMBER_OF_LOOPS) }
      
      context 'when output_type is response-bodies' do
        it 'displays response bodies' do
          expect { http_client.run('response-bodies') }.to output(
            "<html><body><h1>It works!</h1></body></html>\n" * output_count
          ).to_stdout
        end
      end

      context 'when output_type is response-codes-aggregation' do
        it 'displays response code 200 aggregation' do
          expect { http_client.run('response-codes-aggregation') }.to output("200: #{output_count}\n").to_stdout
        end
      end
    end
  end
end
