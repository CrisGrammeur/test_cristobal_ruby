require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.create(name: "Pacioli", email: "pacioli@gmail.com", password: "password") }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is not valid without a name" do
      user.name: nil
      expect(user).not_to be_valid
    end

    it "is not valid without an email" do
      user.email: nil
      expect(user).not_to be_valid
    end

    it "is not valid with an invalid email format" do
        user.email: "invalid-email"
        expect(user).not_to be_valid
    end

    it "is not valid without a password" do
        user.password: nil
        expect(user).not_to be_valid
    end

    it "is not valid with a duplicate email" do
      User.create(name: "Pacioli", email: "pacioli@gmail.com", password: "password")
      duplicate_user = User.new(name: "Another", email: "pacioli@gmail.com", password: "password")
      expect(duplicate_user).not_to be_valid
    end

    it "is not valid with a password shorter than 6 characters" do
      user.password = "123"
      expect(user).not_to be_valid
    end
  end

  # Authentication
  describe "authentication" do
    it "authenticates with valid password" do
      expect(user.authenticate('password')).to eq(user)
    end

    it "does not authenticate with an invalid password" do
      expect(user.authenticate('wrongpassword')).to be_falsey
    end
  end
end