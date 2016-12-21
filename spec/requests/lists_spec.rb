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

      it 'receives all 3 lists' do
        expect(json_body['data'].size).to eq 3
      end
    end

    describe 'pagination' do
      context 'when asking for the first page' do
        before { get('/api/v1/lists?page[number]=1&page[size]=2') }

        it 'receives HTTP status 200' do
          expect(response.status).to eq 200
        end

        it 'receives only two lists' do
          expect(json_body['data'].size).to eq 2
        end

        it 'receives links object with "next" link' do
          expected = "http://www.example.com/api/v1/lists?page[number]=2&page[size]=2"
          expect(URI.unescape(json_body['links']['next'])).to eq expected
        end
      end

      context 'when asking for the second page' do
        before { get('/api/v1/lists?page[number]=2&page[size]=2') }

        it 'receives HTTP status 200' do
          expect(response.status).to eq 200
        end

        it 'receives only one book' do
          expect(json_body['data'].size).to eq 1
        end
      end

      context "when sending invalid 'page' and 'per' parameters" do
        before { get('/api/v1/lists?page[number]=fake&page[size]=10') }

        it 'receives HTTP status 400' do
          expect(response.status).to eq 400
        end

        it 'receives an error' do
          expect(json_body['error']).to_not be nil
        end

        it "receives 'page[number]=fake' as an invalid param" do
          expect(json_body['error']['invalid_params']).to eq 'page[number]=fake'
        end
      end
    end
  end
end
