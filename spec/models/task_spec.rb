RSpec.describe Task, type: :model do
  it { should validate_presence_of(:list_id) }
  it { should validate_presence_of(:title) }

  it { should belong_to(:list) }

  it 'has a valid factory' do
    expect(build(:list)).to be_valid
  end
end
