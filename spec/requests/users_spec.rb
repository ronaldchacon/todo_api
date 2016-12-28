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

  describe "POST /api/v1/users" do
    before { post "/api/v1/users", params: { data: params } }
    context "with valid parameters" do
      let(:params) do
        {
          type: "users",
          attributes: attributes_for(:user),
        }
      end
      it "gets HTTP status 201" do
        expect(response.status).to eq 201
      end

      it "receives the newly created resource" do
        expect(json_body["data"]["attributes"]["email"]).
          to eq "user@foobar.com"
      end

      it "adds a record in the database" do
        expect(User.count).to eq 1
      end

      it "gets the new resource location in the Location header" do
        expect(response.headers["Location"]).to eq(
          "http://www.example.com/api/v1/users/#{User.first.id}",
        )
      end
    end

    context "with invalid parameters" do
      let(:params) do
        {
          attributes: { email: "" },
        }
      end

      it "gets HTTP status 422" do
        expect(response.status).to eq 422
      end

      it "gets error details" do
        expect(response.body).
          to have_jsonapi_errors_for("/data/attributes/email")
      end

      it "does not add a record in the database" do
        expect(User.count).to eq 0
      end
    end
  end

  describe "PATCH /api/v1/users/:id" do
    before { patch "/api/v1/users/#{user.id}", params: { data: params } }
    context "with valid parameters" do
      let(:params) do
        {
          type: "users",
          attributes: attributes_for(:user, email: "foobar@example.com"),
        }
      end

      it "gets HTTP status 200" do
        expect(response.status).to eq 200
      end

      it "receives the updated resource" do
        expect(json_body["data"]["attributes"]["email"]).
          to eq "foobar@example.com"
      end

      it "updates the record in the database" do
        expect(User.first.email).to eq "foobar@example.com"
      end
    end

    context "with invalid parameters" do
      let(:params) do
        {
          attributes: { email: "" },
        }
      end

      it "gets HTTP status 422" do
        expect(response.status).to eq 422
      end

      it "receives error details" do
        expect(response.body).
          to have_jsonapi_errors_for("/data/attributes/email")
      end

      it "does not add a record in the database" do
        expect(User.first.email).to eq "user@foobar.com"
      end
    end
  end

  describe "DELETE /api/v1/users/:id" do
    context "with existing resource" do
      before { delete "/api/v1/users/#{user.id}" }

      it "gets HTTP status 204" do
        expect(response.status).to eq 204
      end

      it "deletes the book from the database" do
        expect(User.count).to eq 0
      end
    end

    context "with nonexistent resource" do
      it "gets HTTP status 404" do
        delete "/api/v1/users/999999999"
        expect(response.status).to eq 404
      end
    end
  end
end
