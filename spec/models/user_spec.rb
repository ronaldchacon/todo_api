RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end
end