module Authentication

	def current_user
		@current_user || User.find_by(auth_token: request.headers['Authorization'])
	end

	def authenticate_user!
		render json: { errors: 'Unathorized Access!' }, status: 401 unless current_user.present?
	end
end
