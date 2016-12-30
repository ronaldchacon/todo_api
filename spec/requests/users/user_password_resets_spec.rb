RSpec.describe 'Users::PasswordResets', type: :request do
  let(:john) { create(:user) }

  describe 'POST /api/v1/password_resets' do
    context 'with valid parameters' do
      let(:params) do
        {
          email: john.email,
          reset_password_redirect_url: 'http://example.com'
        }
      end

      before { post '/api/v1/password_resets', params: { data: params } }

      it 'returns 204' do
        expect(response.status).to eq 204
      end

      it 'sends the reset password email' do
        expect(ActionMailer::Base.deliveries.last.subject)
          .to eq 'Reset your password'
      end

      it 'adds the reset password attributes to "john"' do
        expect(john.reset_password_token).to be nil
        expect(john.reset_password_sent_at).to be nil
        updated = john.reload
        expect(updated.reset_password_token).to_not be nil
        expect(updated.reset_password_sent_at).to_not be nil
        expect(updated.reset_password_redirect_url).to eq 'http://example.com'
      end
    end

    context 'with invalid parameters' do
      let(:params) { { email: john.email } }
      before { post '/api/v1/password_resets', params: { data: params } }
      it 'returns HTTP status 422' do
        expect(response.status).to eq 422
      end
    end

    context 'with nonexistent user' do
      let(:params) { { email: 'fake@example.com' } }
      before { post '/api/v1/password_resets', params: { data: params } }

      it 'returns HTTP status 404' do
        expect(response.status).to eq 404
      end
    end
  end

  describe 'GET /api/v1/password_resets/:reset_token' do
    context 'with existing user (valid token)' do
      subject { get "/api/v1/password_resets/#{john.reset_password_token}" }

      context 'with redirect URL containing parameters' do
        let(:john) { create(:user, :reset_password) }
        it 'redirects to "http://example.com?reset_token=TOKEN"' do
          token = john.reset_password_token
          expect(subject)
            .to redirect_to"http://example.com?reset_token=#{token}"
        end
      end
    end

    context 'with nonexistent user' do
      before { get '/api/v1/password_resets/123' }
      it 'returns HTTP status 404' do
        expect(response.status).to eq 404
      end
    end
  end

  describe "PATCH /api/v1/password_resets/:reset_token" do
    context "with existing user (valid token)" do
      let(:john) { create(:user, :reset_password) }

      before do
        patch "/api/v1/password_resets/#{john.reset_password_token}",
              params: { data: params }
      end

      context "with valid parameters" do
        let(:params) { { password: "barfoo", password_confirmation: "barfoo" } }

        it "returns HTTP status 204" do
          expect(response.status).to eq 204
        end

        it "updates the password" do
          expect(john.reload.valid_password?("barfoo")).to_not be false
        end
      end

      context "with invalid parameters" do
        let(:params) { { password: "" } }
        it "returns HTTP status 422" do
          expect(response.status).to eq 422
        end
      end
    end

    context "with nonexistent user" do
      before do
        patch "/api/v1/password_resets/123",
              params: { data: { password: "password" } }
      end

      it "returns HTTP status 404" do
        expect(response.status).to eq 404
      end
    end
  end
end
