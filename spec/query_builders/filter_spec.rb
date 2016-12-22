RSpec.describe Filter do
  let(:personal) { create(:personal) }
  let(:work) { create(:work) }
  let(:school) { create(:school) }
  let(:lists) { [personal, work, school] }

  let(:scope) { List.all }
  let(:params) { {} }
  let(:filter) { Filter.new(scope, params) }
  let(:filtered) { filter.filter }

  before { lists }

  describe '#filter' do
    context 'without any parameters' do
      it 'returns the scope unchanged' do
        expect(filtered).to eq scope
      end
    end

    context 'with valid parameters' do
      context 'with "title_eq=Personal List"' do
        let(:params) { { 'q' => { 'title_eq' => 'Personal List' } } }
        it 'gets only "Personal List" back' do
          expect(filtered.first.id).to eq personal.id
          expect(filtered.size).to eq 1
        end
      end

      context 'with "title_cont=Personal"' do
        let(:params) { { 'q' => { 'title_cont' => 'Personal' } } }
        it 'gets only Personal List" back' do
          expect(filtered.size).to eq 1
        end
      end

      context 'with "title_notcont=Personal List"' do
        let(:params) { { 'q' => { 'title_notcont' => 'Personal List' } } }
        it 'gets "School List and Work List" back' do
          expect(filtered.first.id).to eq work.id
          expect(filtered.last.id).to eq school.id
          expect(filtered.size).to eq 2
        end
      end

      context 'with "title_start=Per"' do
        let(:params) { { 'q' => { 'title_start' => 'Per' } } }
        it 'gets only "Personal List" back' do
          expect(filtered.size).to eq 1
        end
      end

      context 'with "title_end=List"' do
        let(:params) { { 'q' => { 'title_end' => 'List' } } }
        it 'gets all lists back' do
          expect(filtered.first).to eq personal
          expect(filtered.second).to eq work
          expect(filtered.third).to eq school
        end
      end

      context 'with "created_at_lt=2016-12-19"' do
        let(:params) { { 'q' => { 'created_at_lt' => '2016-12-19' } } }
        it 'gets only the lists with released_on before 2016-12-19' do
          expect(filtered.first.title).to eq personal.title
          expect(filtered.last.title).to eq school.title
          expect(filtered.size).to eq 2
        end
      end

      context 'with "created_at_gt=2016-12-20"' do
        let(:params) { { 'q' => { 'created_at_gt' => '2016-12-20' } } }
        it 'gets only the work list' do
          expect(filtered.first.title).to eq work.title
          expect(filtered.size).to eq 1
        end
      end
    end

    context 'with invalid parameters' do
      context 'with invalid column name "fid"' do
        let(:params) { { 'q' => { 'fid_gt' => '2' } } }
        it 'raises a "QueryBuilderError" exception' do
          expect { filtered }.to raise_error(QueryBuilderError)
        end
      end

      context 'with invalid predicate "gtz"' do
        let(:params) { { 'q' => { 'id_gtz' => '2' } } }
        it 'raises a "QueryBuilderError" exception' do
          expect { filtered }.to raise_error(QueryBuilderError)
        end
      end
    end
  end
end
