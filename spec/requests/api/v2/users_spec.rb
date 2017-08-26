require 'rails_helper'

RSpec.describe 'Users API', type: :request do

  let!(:user) { create(:user) }

  let(:user_id) { user.id }

  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v2',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end

  before { host! 'api.taskmanager.dev' }

  describe 'GET /users/:id' do
    context 'when the user exists' do
      before do
        get "/users/#{user_id}", params: {}, headers: headers
      end

      it 'returns the user' do
        expect(json_response[:_id][:$oid]).to eq(user_id.to_s)
      end

      it 'returns status code :ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the user does not exist' do
      it 'returns status code :not_found' do
        headers['Authorization'] = 999

        get "/users/#{user_id}", params: {}, headers: headers

        expect(response).to have_http_status(:unauthorized)
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
        expect(json_response[:email]).to eq user_params[:email]
      end

      it 'returns status code :created' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'when request params are invalid' do
      let(:user_params){ attributes_for(:user, email: 'invalid_email@') }

      it 'returns status code :unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the json data with the errors' do
        expect(json_response).to have_key(:errors)
        expect(json_response[:errors][:email].first).to eq 'is invalid'
      end
    end
  end

  describe 'PUT /users:id' do
    before do
      put "/users/#{user_id}", params: { user: user_params }.to_json, headers: headers
    end

    context 'when request params are valid' do
      let(:user_params){ { email: Faker::Internet.email } }

      it 'returns json data for the updated user' do
        expect(json_response[:email]).to eq user_params[:email]
      end

      it 'returns status code :ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when request params are invalid' do
      let(:user_params){ attributes_for(:user, email: 'invalid_email@') }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the json data with the errors' do
        expect(json_response).to have_key(:errors)
        expect(json_response[:errors][:email].first).to eq 'is invalid'
      end
    end
  end

  describe 'DELETE /users:id' do
    before do
      delete "/users/#{user_id}", params: {}, headers: headers
    end

    it 'returns remove the user' do
      expect( User.where(id: user_id).first).to be_nil
    end

    it 'returns status code :no_content' do
      expect(response).to have_http_status(:no_content)
    end
  end
end
