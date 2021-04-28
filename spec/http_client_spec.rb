require_relative '../http_client'

describe 'HttpClient' do
  let(:url) { 'http://0.0.0.0:8080/' }
  let(:query_string) { 'p=1, q=2, z = abc' }
  let(:number_of_threads) { 10 }
  let(:number_of_loops) { 10 }
  let(:output_count) { number_of_threads * number_of_loops }
  let(:http_client) {
    HttpClient.new(url, http_method, query_string, number_of_threads, number_of_loops, output_type)
  }

  shared_examples 'response-bodies displayer' do |method|
    it 'displays all response-bodies' do
      expect { http_client.send(method) }.to output(
        "<html><body><h1>It works!</h1></body></html>\n" * output_count
      ).to_stdout
    end
  end

  shared_examples 'response-codes-aggregation displayer' do |method|
    it 'displays response code aggregation for all codes 200' do
      expect { http_client.send(method) }.to output("200: #{output_count}\n").to_stdout
    end
  end

  describe '#run' do
    context 'when method is get and output_type is response-bodies' do
      let(:http_method) { 'get' }
      let(:output_type) { 'response-bodies' }

      it_behaves_like 'response-bodies displayer', :run
    end

    context 'when method is post and output_type is response-codes-aggregation' do
      let(:http_method) { 'post' }
      let(:output_type) { 'response-codes-aggregation' }

      it_behaves_like 'response-codes-aggregation displayer', :run
    end
  end

  shared_context 'http_client has received get responses' do
    let(:http_method) { 'get' }
    let(:output_type) { '' }

    before { http_client.send(:send_requests_concurrently_in_loops) }
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
      let(:output_type) { 'response-codes-aggregation' }

      it_behaves_like 'response-codes-aggregation displayer', :display
    end
    
    context 'when output_type is response-bodies' do
      let(:output_type) { 'response-bodies' }

      it_behaves_like 'response-bodies displayer', :display
    end

    context 'when output_type is other' do
      let(:output_type) { 'other' }
      
      it 'raises UnsupportedOutputTypeError' do
        expect { http_client.send(:display) }.to raise_error(UnsupportedOutputTypeError)
      end
    end
  end

  describe '#display_response_codes_aggregation' do
    include_context 'http_client has received get responses'

    it_behaves_like 'response-codes-aggregation displayer', :display_response_codes_aggregation
  end

  describe '#aggregate_response_codes' do
    include_context 'http_client has received get responses'
    
    it 'aggregates response codes that are all 200' do
      expect(http_client.send(:aggregate_response_codes)).to eq({ '200' => output_count })
    end
  end

  describe '#display_response_bodies' do
    include_context 'http_client has received get responses'

    it_behaves_like 'response-bodies displayer', :display_response_bodies
  end
end
