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
		it { is_expected.to validate_uniqueness_of(:auth_token) }
		it { is_expected.to validate_confirmation_of(:password) }

		it { expect(user).to be_valid }

	  it { is_expected.to have_many(:tasks).with_dependent(:destroy) }

		describe '#info' do
			it 'return email, created_at and token' do
				user.save!

				allow(Devise).to receive(:friendly_token).and_return('abu71878soTOKEN')

				expect(user.info).to eq "#{user.email} - #{user.created_at} - Token: abu71878soTOKEN"
			end
		end

		describe '#generate_authentication_token!' do
			it 'generates a unique auth token' do
				allow(Devise).to receive(:friendly_token).and_return('abc123xyzTOKEN')
				user.generate_authentication_token!

				expect(user.auth_token).to eq('abc123xyzTOKEN')
			end

			it 'generates another auth token when the current auth token already has been taken' do
				allow(Devise).to receive(:friendly_token).and_return('abc123tokenxyz', 'abc123tokenxyz', 'abcXYZ123456789')
				existing_user = create(:user)
				user.generate_authentication_token!

				expect(user.auth_token).not_to eq(existing_user.auth_token)
			end
		end
	end
end
