module AuthHelpers
    def login_user(user)
      token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base, 'HS256')
      request.headers['Authorization'] = "Bearer #{token}"
    end
  end
  
  RSpec.configure do |config|
    config.include AuthHelpers, type: :controller
  end
  