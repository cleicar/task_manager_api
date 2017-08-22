require 'rails_helper'

RSpec.describe User, type: :model do

	let(:user) { build(:user) }

  describe 'Testing user fields' do
  	it { is_expected.to be_mongoid_document }

		it { is_expected.to have_fields(:email).of_type(String) }

		it { is_expected.to respond_to(:password) }
		it { is_expected.to respond_to(:password_confirmation) }

		it { is_expected.to validate_presence_of(:email) }
		it { is_expected.to validate_uniqueness_of(:email) }
		it { is_expected.to validate_confirmation_of(:password) }

		it { expect(user).to be_valid }
	end
end
