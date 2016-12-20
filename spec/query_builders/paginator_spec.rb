RSpec.describe Paginator do
  let(:personal) { create(:personal) }
  let(:work) { create(:work) }
  let(:school) { create(:school) }

  let(:lists) { [personal, work, school] }

  let(:scope) { List.all }
  let(:params) { { 'page' => { 'number' => '1', 'size' => '2' } } }
  let(:paginator) { Paginator.new(scope, params) }
  let(:paginated) { paginator.paginate }

  before { lists }

  describe '#paginate' do
    it 'paginates the collection with 2 lists' do
      expect(paginated.size).to eq 2
    end

    it 'contains personal as the first paginated item' do
      expect(paginated.first).to eq personal
    end

    it 'contains work as the last paginated item' do
      expect(paginated.last).to eq work
    end
  end
end
