require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { {name: "Pacioli", email: "pacioli@gmail.com", password: "azerty"} }

  # Test de création d'utilisateur avec des paramètres valides
  describe "POST /users" do
    context "with valid parameters" do
      let(:valid_attributes) do
        {
          user: {
            name: "Pacioli",
            email: "pacioli@gmail.com",
            password: "azerty"
          }
        }
      end

      it "creates a new user" do
        expect {
          post '/users', params: valid_attributes
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["name"]).to eq("Pacioli")
        expect(json_response["email"]).to eq("pacioli@gmail.com")
      end
    end

    # Test de création d'utilisateur avec des paramètres invalides
    context "with invalid parameters" do
        let(:invalid_attributes) do
            {
            user: {
                name: "",
                email: "invalid-email",
                password: ""
            }
            }
        end

        it "does not create a new user and returns errors" do
            expect {
            post '/users', params: invalid_attributes
            }.not_to change(User, :count)

            expect(response).to have_http_status(422)
            json_response = JSON.parse(response.body)
            expect(json_response["email"]).to include("is invalid")
            expect(json_response["errors"]["password"]).to include("can't be blank")
        end
    end
  end
  describe 'POST /login' do
    it 'logs in the user and returns a token' do
      post '/login', params: { name: 'Pacioli', email: 'pacioli@gmail.com', password: 'azerty' }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to have_key("token")
    end
  end
end