require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
    # render_views false

    controller do
        before_action :authenticate_user

        def index
            render plain: "Hello"
        end
    end

    let(:user) { User.create(name: 'Pacioli', email: 'pacioli@gmail.com', password: 'azerty') }
    let(:token) { JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base, 'HS256') }

    describe "Authorization with JWT" do
        context "with valid token" do
            it "allows access" do
                request.headers['Authorization'] = "Bearer #{token}"
                get :index
                expect(response).to have_http_status(:ok)
            end
        end

        context "with no token" do
            it "denies access" do
                get :index
                expect(response).to have_http_status(401)
            end
        end

        context "with invalid token" do
            it "denies access" do
                request.headers['Authorization'] = "Bearer invalidtoken"
                get :index
                expect(response).to have_http_status(401)
            end
        end

        context "with expired token" do
            let(:expired_token) { JWT.encode({ user_id: user.id, exp: 1.hour.ago.to_i }, Rails.application.credentials.secret_key_base, 'HS256') }

            it "denies access" do
                request.headers['Authorization'] = "Bearer #{expired_token}"
                get :index
                expect(response).to have_http_status(401)
            end
        end
    end
end