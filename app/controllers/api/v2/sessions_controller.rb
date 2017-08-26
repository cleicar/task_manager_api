class Api::V2::SessionsController < ApplicationController

	skip_before_action :authenticate_user!

	def create
		user = User.where(email: sessions_params[:email]).first
		if user && user.valid_password?(sessions_params[:password])
			sign_in user, store: false
			user.generate_authentication_token!
			user.save
			render json: user, status: :ok
		else
			render json: { errors: 'Invalid password or email' }, status: :unauthorized
		end
	end

	def destroy
		user = User.where(auth_token: params[:id]).first
		user.generate_authentication_token!
		user.save!
		head :no_content
	end

	private
	def sessions_params
		params.require(:session).permit(:email, :password)
	end
end
