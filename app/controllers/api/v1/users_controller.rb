class Api::V1::UsersController < ApplicationController
	before_action :set_user, only: [:update, :show, :destroy]
	before_action :authenticate_user!, only: [:show, :update, :destroy]

	respond_to :json

	# GET /users/:id
	def show
		respond_with @user, status: :ok
	end

	# POST /users
	def create
    user = User.new(user_params)

    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
	end

	# PUT /users/:id
	def update
		if @user.update_attributes(user_params)
      render json: @user, status: :ok
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
	end

	# DELETE /users/:id
	def destroy
		@user.destroy
		head :no_content
	end

	private
	def user_params
		params.require(:user).permit(:email, :password, :password_confirmation)
	end

	def set_user
		@user = current_user
    head :not_found if @user.blank?
	end
end
