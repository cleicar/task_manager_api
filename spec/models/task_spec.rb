require 'rails_helper'

RSpec.describe Task, type: :model do

	let(:user) { build(:user) }
	let(:task) { build(:task) }

	it { is_expected.to be_mongoid_document }

	it { is_expected.to have_fields(:title).of_type(String) }
	it { is_expected.to have_fields(:description).of_type(String) }
	it { is_expected.to have_fields(:done).of_type(Mongoid::Boolean) }
	it { is_expected.to have_fields(:deadline).of_type(Time) }

	it { is_expected.to validate_presence_of(:title) }
	it { is_expected.to validate_presence_of(:user_id) }

	it { is_expected.to belong_to(:user) }

	it { expect(task).to be_valid }
end
