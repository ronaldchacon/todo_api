RSpec.describe List, type: :model do
  it { should validate_presence_of(:title) }

  it { should have_many(:tasks) }

  it 'has a valid factory' do
    expect(build(:list)).to be_valid
  end
end
