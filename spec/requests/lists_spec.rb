RSpec.describe 'Lists', type: :request do
  let(:personal) { create(:personal) }
  let(:work) { create(:work) }
  let(:school) { create(:school) }

  let(:lists) { [personal, work, school] }

  describe 'GET /api/v1/lists' do
    before { lists }

    context 'default behavior' do
      before { get '/api/v1/lists' }

      it 'gets HTTP status 200' do
        expect(response).to have_http_status(200)
      end

      it 'receives a json with the "data" root key' do
        expect(json_body['data']).to_not be nil
      end

      it 'receives all 3 books' do
        expect(json_body['data'].size).to eq 3
      end
    end

    describe 'pagination' do

    end
  end
end
