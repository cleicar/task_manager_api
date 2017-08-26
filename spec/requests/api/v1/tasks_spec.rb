require 'rails_helper'

RSpec.describe 'Task API' do

  before { host! 'api.taskmanager.dev' }

  let!(:user) { create(:user) }

  let(:headers) do
		{
		  'Content-Type' => Mime[:json].to_s,
		  'Accept' => 'application/vnd.taskmanager.v1',
		  'Authorization' => user.auth_token
		}
  end

  describe 'GET /tasks' do
    before do
      create_list(:task, 5, user_id: user.id)

      get '/tasks', params: {}, headers: headers
    end

    it 'returns status as ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns 5 tasks from database' do
      expect(json_response[:tasks].count).to eq(5)
    end
  end

  describe 'GET /tasks/:id' do
    let(:task) { create(:task, user_id: user.id) }

    before { get "/tasks/#{task.id}", params: {}, headers: headers }

    it 'returns status as ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the json for task' do
      expect(json_response[:title]).to eq(task.title)
    end
  end

  describe 'POST /tasks' do
    before do
      post '/tasks', params: { task: task_params }.to_json, headers: headers
    end

    context 'when the params are valid' do
      let(:task_params) { attributes_for(:task) }

      it 'returns status as created' do
        expect(response).to have_http_status(:created)
      end

      it 'saves the task in the database' do
        expect( Task.find_by(title: task_params[:title]) ).not_to be_nil
      end

      it 'returns the json for created task' do
        expect(json_response[:title]).to eq(task_params[:title])
      end

      it 'assigns the created task to the current user' do
        expect(json_response[:user_id][:$oid]).to eq user.id.to_s
      end
    end

    context 'when the params are invalid' do
      let(:task_params) { attributes_for(:task, title: ' ') }

      it 'returns status as unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not save the task in the database' do
        expect( Task.find_by(title: task_params[:title]) ).to be_nil
      end

      it 'returns the json error for title' do
        expect(json_response[:errors]).to have_key(:title)
      end
    end
  end

  describe 'PUT /tasks/:id' do
    let!(:task) { create(:task, user_id: user.id) }

    before do
      put "/tasks/#{task.id}", params: { task: task_params }.to_json, headers: headers
    end

    context 'when the params are valid' do
      let(:task_params){ { title: 'New task title' } }

      it 'returns status as ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the json for updated task' do
        expect(json_response[:title]).to eq(task_params[:title])
      end

      it 'updates the task in the database' do
        expect( Task.find_by(title: task_params[:title]) ).not_to be_nil
      end
    end

    context 'when the params are invalid' do
      let(:task_params){ { title: ' '} }

      it 'returns status as unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the json error for title' do
        expect(json_response[:errors]).to have_key(:title)
      end

      it 'does not update the task in the database' do
        expect( Task.find_by(title: task_params[:title]) ).to be_nil
      end
    end
  end

  describe 'DELETE /tasks/:id' do
    let!(:task) { create(:task, user_id: user.id) }

    before do
      delete "/tasks/#{task.id}", params: {}, headers: headers
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the task from the database' do
      expect(Task.find(task.id)).to be_nil
    end
  end
end
