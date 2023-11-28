require 'rails_helper'

RSpec.describe Recipe, type: :model do
  let(:user) { FactoryBot.create(:user)}
  let(:recipe) { FactoryBot.create(:recipe, user_id: user.id)}

  # Association tests
  it { should belong_to(:user) }

  # Validation tests
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:ingredients) }
  it { should validate_presence_of(:steps) }

  it { should validate_length_of(:title).is_at_least(5) }
  it { should validate_length_of(:description).is_at_least(20) }
end
