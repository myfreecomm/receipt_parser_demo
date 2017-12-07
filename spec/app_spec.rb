require File.expand_path '../spec_helper.rb', __FILE__

describe 'Receipt Parser Demo App' do
  describe '#POST /inbound' do
    context 'when body is not supported' do
      it 'does return status 422' do
        post '/inbound', { key: 'value' }.to_json

        expect(last_response.status).to eq 422
      end
    end

    context 'when body is supported' do
      it 'does return status 200' do
        allow_any_instance_of(Postmark::ApiClient).to receive(:deliver).
          and_return(true)

        post '/inbound', { From: 'some@email.com' }.to_json

        expect(last_response.status).to eq 200
      end

      it 'does send an email' do
        expect_any_instance_of(Postmark::ApiClient).to receive(:deliver).
          and_return(true)

        post '/inbound', { From: 'some@email.com' }.to_json
      end
    end
  end
end
