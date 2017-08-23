class Api::V1::SessionsController < ApplicationController

	def create
		user = User.where(email: sessions_params[:email]).first

		if user && user.valid_password?(sessions_params[:password])
			render json: user, status: :ok
		end
	end

	private
	def sessions_params
		params.require(:session).permit(:email, :password)
	end
end
