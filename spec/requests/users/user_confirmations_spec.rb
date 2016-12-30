RSpec.describe "Users::Confirmations", type: :request do
  describe "GET /api/v1/confirmations/:confirmation_token" do
    context "with existing token" do
      context "without confirmation redirect url" do
        let(:john) { create(:user, :with_confirmation_token) }

        before { get "/api/v1/confirmations/#{john.confirmation_token}" }

        it "returns HTTP status 200" do
          expect(response.status).to eq 200
        end

        it 'renders "Your are now confirmed!"' do
          expect(response.body).to eq "You are now confirmed!"
        end
      end
    end

    context "with nonexistent token" do
      before { get "/api/v1/confirmations/fake" }
      it "returns HTTP status 404" do
        expect(response.status).to eq 404
      end

      it 'renders "Token not found"' do
        expect(response.body).to eq "Token not found"
      end
    end
  end
end
