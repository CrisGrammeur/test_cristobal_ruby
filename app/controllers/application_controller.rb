class ApplicationController < ActionController::API
    include ActionController::Cookies

    before_action :authenticate_user

    SECRET_KEY = Rails.application.secrets.secret_key_base

    private

    def authenticate_user
        token = request.headers['Authorization']

        if token.present? && token.start_with?('Bearer ')
            token = token.split(' ').last
            decoded_token = decode_jwt(token)
            @current_user = User.find_by(id: decoded_token[:user_id]) if decoded_token
        end

        render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user
    end

    def encode_jwt(payload, exp = 24.hours.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, SECRET_KEY, 'HS256')
    end

    def decode_jwt(token)
        JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' }).first.symbolize_keys
    rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError => e
        Rails.logger.error("JWT Error: #{e.message}")
    end
end
