RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }

  describe "GET api/v1/users/:id" do
    context "with existing resource" do
      before { get "/api/v1/users/#{user.id}" }

      it "gets HTTP status 200" do
        expect(response.status).to eq 200
      end

      it 'receives "user" as JSON' do
        expect(json_body["data"]["id"]).to eq user.id.to_s
      end
    end

    context "with nonexistent resource" do
      it "gets HTTP status 404" do
        get "/api/v1/users/999999999"
        expect(response.status).to eq 404
      end
    end
  end
end
