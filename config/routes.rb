Rails.application.routes.draw do

  # Integração com a Escrita Fiscal
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api'}, path: '/' do
  	namespace :v1 do
  		resources :tasks
  	end
  end

end
