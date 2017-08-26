class Api::V2::TasksController < ApplicationController
	before_action :set_task, only: [:update, :show, :destroy]

	respond_to :json

	# GET /tasks
	def index
		tasks = current_user.tasks
		render json: { tasks: tasks }, status: :ok
	end

	# GET /tasks/:id
	def show
    render json: @task, status: :ok
  end

  # POST /tasks
  def create
    task = current_user.tasks.build(task_params)

    if task.save
      render json: task, status: :created
    else
      render json: { errors: task.errors }, status: :unprocessable_entity
    end
  end

  # PUT /tasks/:id
  def update
    if @task.update_attributes(task_params)
      render json: @task, status: 200
    else
      render json: { errors: @task.errors }, status: 422
    end
  end

  def destroy
    @task.destroy
    head 204
  end

  private
  def task_params
    params.require(:task).permit(:title, :description, :deadline, :done)
  end

  def set_task
  	@task = current_user.tasks.find(params[:id])
    head :not_found if @task.blank?
  end
end
