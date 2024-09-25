require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { User.create(name: 'Pacioli', email: 'pacioli@gmail.com', password: 'azerty') }

  describe "POST #create (login)" do
    context "with valid credentials" do
      it "logs in the user and returns a token" do
        post :create, params: { email: user.email, password: 'azerty' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['token']).to be_present
      end
    end

    context "with invalid credentials" do
      it "returns an error" do
        post :create, params: { email: user.email, password: 'wrongpassword' }
        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)['token']).to be_nil
      end
    end
  end

  describe "DELETE #destroy (logout)" do
    it "logs out the user" do
      delete :destroy
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Logged out successfully")
    end
  end
end
