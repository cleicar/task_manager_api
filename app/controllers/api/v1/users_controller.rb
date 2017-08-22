class Api::V1::UsersController < ApplicationController
	respond_to :json

	# GET /users/:id
	def show
		@user = User.find(params[:id])
		respond_with @user, status: :ok
	rescue
		head :not_found
	end

	# POST /users
	def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
	end

	private
	def user_params
		params.require(:user).permit(:email, :password, :password_confirmation)
	end
end
