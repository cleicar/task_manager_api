require 'rails_helper'

RSpec.describe "Sessions API", type: :request do

	let!(:user) { create(:user) }

	let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v1',
      'Content-Type' => Mime[:json].to_s,
    }
  end

  before { host! 'api.taskmanager.dev' }

  describe "POST /sessions" do
  	before do
  		post '/sessions', params: { session: credentials }.to_json, headers: headers
  	end

  	context 'when credentials are correct' do
  		let!(:credentials) { {email: user.email, password: '12345678'} }

	  	it 'returns status code :ok' do
	  		expect(response).to have_http_status(:ok)
	  	end

	  	it 'returns the json data for the users with auth token' do
	  		expect(json_response[:auth_token]).to eq user.auth_token
	  	end
	  end
	end
end
