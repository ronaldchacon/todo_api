RSpec.describe Sorter do
  let(:personal) { create(:personal) }
  let(:work) { create(:work) }
  let(:school) { create(:school) }
  let(:lists) { [personal, work, school] }

  let(:scope) { List.all }
  let(:params) { HashWithIndifferentAccess.new(sort: 'id', dir: 'desc') }
  let(:sorter) { Sorter.new(scope, params) }
  let(:sorted) { sorter.sort }

  before { lists }

  describe '#sort' do
    context 'without any parameters' do
      let(:params) { {} }
      it 'returns the scope unchanged' do
        expect(sorted).to eq scope
      end
    end

    context 'with valid parameter id' do
      it 'sorts the collection by "id desc"' do
        expect(sorted.first.id).to eq school.id
        expect(sorted.last.id).to eq personal.id
      end
    end

    context 'with valid parameter title' do
      let(:params) { HashWithIndifferentAccess.new(sort: 'title', dir: 'asc') }
      it 'sorts the collection by "title asc"' do
        expect(sorted.first).to eq personal
        expect(sorted.last).to eq work
      end
    end

    context 'with invalid parameters' do
      let(:params) { HashWithIndifferentAccess.new(sort: 'fid', dir: 'desc') }
      it 'raises a QueryBuilderError exception' do
        expect { sorted }.to raise_error(QueryBuilderError)
      end
    end
  end
end
