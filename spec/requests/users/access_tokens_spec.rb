RSpec.describe 'Users::AccessTokens', type: :request do
  let(:john) { create(:user) }

  describe 'POST /api/v1/access_tokens' do
    before { post '/api/v1/access_tokens', params: { data: params } }

    context 'with existing user' do
      context 'with valid password' do
        let(:params) do
          { email: john.email, password: 'foobar' }
        end

        it 'gets HTTP status 201 Created' do
          expect(response.status).to eq 201
        end

        it 'receives an access token' do
          expect(json_body['meta']['token']).to_not be nil
        end

        it 'receives the user embedded' do
          expect(json_body['data']['attributes']['user-id']).to eq john.id
        end
      end

      context 'with invalid password' do
        let(:params) { { email: john.email, password: 'fake' } }

        it 'returns 422 Unprocessable Entity' do
          expect(response.status).to eq 422
        end
      end
    end

    context 'with nonexistent user' do
      let(:params) { { email: 'unknown', password: 'fake' } }

      it 'gets HTTP status 404 Not Found' do
        expect(response.status).to eq 404
      end
    end
  end

  describe "DELETE /api/access_tokens" do
    context "with valid API key" do
      before { delete "/api/v1/access_tokens", headers: headers }

      context "with valid access token" do
        let(:access_token) { create(:access_token, user: john) }
        let(:token) { access_token.generate_token }
        let(:token_str) { "#{john.id}:#{token}" }
        let(:headers) do
          { "HTTP_AUTHORIZATION" => "Token access_token=#{token_str}" }
        end

        it "returns 204 No Content" do
          expect(response.status).to eq 204
        end

        it "destroys the access token" do
          expect(john.reload.access_tokens.size).to eq 0
        end
      end

      context "with invalid access token" do
        let(:headers) do
          { "HTTP_AUTHORIZATION" => "Token access_token=1:fake" }
        end

        it "returns 401" do
          expect(response.status).to eq 401
        end
      end
    end
  end
end
