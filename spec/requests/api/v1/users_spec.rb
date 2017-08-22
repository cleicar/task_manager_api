require 'rails_helper'

RSpec.describe 'Users API', type: :request do

  let!(:user) { create(:user) }

  let(:user_id) { user.id }

  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v1',
      'Content-Type' => Mime[:json].to_s,
    }
  end

  before { host! 'api.taskmanager.dev' }

  describe 'GET /users/:id' do
    before do
      get "/users/#{user_id}", params: {}, headers: headers
    end

    context 'when the user exists' do
      it 'returns the user' do
        expect(json_response[:_id]['$oid']).to eq(user_id.to_s)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the user does not exist' do
      let(:user_id) { 999 }

      it 'returns status coide 404' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /users' do
    before do
      post '/users', params: { user: user_params }.to_json, headers: headers
    end

    context 'when request params are valid' do
      let(:user_params){ attributes_for(:user, email: Faker::Internet.email) }

      it 'returns json with the created user' do
        expect(json_response['email']).to eq user_params[:email]
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'when request params are invalid' do
      let(:user_params){ attributes_for(:user, email: 'invalid_email@') }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the json data with the errors' do
        expect(json_response).to have_key(:errors)
      end
    end
  end
end
