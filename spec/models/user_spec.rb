require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = User.new(name: "Pacioli", email: "pacioli@gmail.com", password: "password")
      expect(user).to be_valid
    end

    it "is not valid without a name" do
      user = User.new(name: nil, email: "pacioli@gmail.com", password: "password")
      expect(user).not_to be_valid
    end

    it "is not valid without an email" do
      user = User.new(name: "Pacioli", email: nil, password: "password")
      expect(user).not_to be_valid
    end

    it "is not valid with an invalid email format" do
        user = User.new(name: "Pacioli", email: "invalid-email", password: "azerty")
        expect(user).not_to be_valid
    end

    it "is not valid without a password" do
        user = User.new(name: "Pacioli", email: "pacioli@gmail.com", password: nil)
        expect(user).not_to be_valid
    end

    it "is not valid with a duplicate email" do
      User.create(name: "Pacioli", email: "pacioli@gmail.com", password: "password")
      duplicate_user = User.new(name: "Another", email: "pacioli@gmail.com", password: "password")
      expect(duplicate_user).not_to be_valid
    end
  end
end