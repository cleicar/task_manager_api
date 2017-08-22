require 'rails_helper'

RSpec.describe 'Users API', type: :request do

	let!(:user) { create(:user) }
	let!(:user_id) { user.id }

	describe "GET /users:id" do
		before do
			headers = { "Accept" => "application/vdn.taskmanager.v1"}

			get "/users/#{user_id}", {}, headers
		end

		context "when user exists" do
			it "return the user" do
				expect(json_response).to eq user_id
			end
		end
	end

end
