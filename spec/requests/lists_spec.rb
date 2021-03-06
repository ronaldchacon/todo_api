RSpec.describe "Lists", type: :request do
  include_context "Skip Auth"
  let(:user) { create(:user) }
  let(:personal) { create(:personal, user: user) }
  let(:work) { create(:work, user: user) }
  let(:school) { create(:school, user: user) }

  let(:lists) { [personal, work, school] }

  describe "GET /api/v1/lists" do
    before { lists }

    context "default behavior" do
      before { get "/api/v1/lists" }

      it "gets HTTP status 200" do
        expect(response).to have_http_status(200)
      end

      it 'receives a json with the "data" root key' do
        expect(json_body["data"]).to_not be nil
      end

      it "receives all 3 lists" do
        expect(json_body["data"].size).to eq 3
      end
    end

    describe "pagination" do
      context "when asking for the first page" do
        before { get("/api/v1/lists?page[number]=1&page[size]=2") }

        it "receives HTTP status 200" do
          expect(response.status).to eq 200
        end

        it "receives only two lists" do
          expect(json_body["data"].size).to eq 2
        end

        it 'receives links object with "next" link' do
          expected = "http://www.example.com/api/v1/lists?page[number]=2&page[size]=2"
          expect(URI.unescape(json_body["links"]["next"])).to eq expected
        end
      end

      context "when asking for the second page" do
        before { get("/api/v1/lists?page[number]=2&page[size]=2") }

        it "receives HTTP status 200" do
          expect(response.status).to eq 200
        end

        it "receives only one book" do
          expect(json_body["data"].size).to eq 1
        end
      end

      context "when sending invalid 'page' and 'per' parameters" do
        before { get("/api/v1/lists?page[number]=fake&page[size]=10") }

        it "receives HTTP status 400" do
          expect(response.status).to eq 400
        end

        it "receives an error" do
          expect(json_body["error"]).to_not be nil
        end

        it "receives 'page[number]=fake' as an invalid param" do
          expect(json_body["error"]["invalid_params"]).to eq "page[number]=fake"
        end
      end
    end

    describe "sorting" do
      context 'with valid column name "id"' do
        it 'sorts the lists by "id desc"' do
          get("/api/v1/lists?sort=id&dir=desc")
          expect(json_body["data"].first["id"].to_i).to eq school.id
          expect(json_body["data"].last["id"].to_i).to eq personal.id
        end
      end

      context 'with invalid column name "fid"' do
        before { get "/api/v1/lists?sort=fid&dir=asc" }

        it 'gets "400 Bad Request" back' do
          expect(response.status).to eq 400
        end

        it "receives an error" do
          expect(json_body["error"]).to_not be nil
        end

        it 'receives "sort=fid" as an invalid param' do
          expect(json_body["error"]["invalid_params"]).to eq "sort=fid"
        end
      end
    end

    describe "filtering" do
      context 'with valid filtering param "q[title_cont]=Personal"' do
        it 'receives "Personal List" back' do
          get("/api/v1/lists?q[title_cont]=Personal")
          expect(json_body["data"].first["id"].to_i).to eq personal.id
          expect(json_body["data"].size).to eq 1
        end
      end

      context 'with invalid filtering param "q[ftitle_cont]=Personal"' do
        before { get("/api/v1/lists?q[ftitle_cont]=Personal") }
        it 'gets "400 Bad Request" back' do
          expect(response.status).to eq 400
        end

        it "receives an error" do
          expect(json_body["error"]).to_not be nil
        end

        it 'receives "q[ftitle_cont]=Personal" as an invalid param' do
          expect(json_body["error"]["invalid_params"]).to eq "q[ftitle_cont]=Personal"
        end
      end
    end
  end

  describe "GET /api/v1/lists/:id" do
    context "with existing resource" do
      before { get "/api/v1/lists/#{personal.id}" }
      it "gets HTTP status 200" do
        expect(response.status).to eq 200
      end

      it 'receives the "Personal List" as JSON' do
        expect(json_body["data"]["id"]).to eq personal.id.to_s
      end
    end

    context "with nonexistent resource" do
      it "gets HTTP status 404" do
        get "/api/v1/lists/999999999"
        expect(response.status).to eq 404
      end
    end
  end

  describe "POST /api/v1/lists" do
    before { post "/api/v1/lists", params: { data: params } }
    context "with valid parameters" do
      let(:params) do
        {
          type: "lists",
          attributes: attributes_for(:personal),
        }
      end
      it "gets HTTP status 201" do
        expect(response.status).to eq 201
      end

      it "receives the newly created resource" do
        expect(json_body["data"]["attributes"]["title"]).to eq "Personal List"
      end

      it "adds a record in the database" do
        expect(List.count).to eq 1
      end

      it "gets the new resource location in the Location header" do
        expect(response.headers["Location"]).to eq(
          "http://www.example.com/api/v1/lists/#{List.first.id}",
        )
      end
    end

    context "with invalid parameters" do
      let(:params) do
        {
          attributes: { title: "" },
        }
      end

      it "gets HTTP status 422" do
        expect(response.status).to eq 422
      end

      it "gets error details" do
        expect(response.body).
          to have_jsonapi_errors_for("/data/attributes/title")
      end

      it "does not add a record in the database" do
        expect(List.count).to eq 0
      end
    end
  end

  describe "PATCH /api/v1/lists/:id" do
    before { patch "/api/v1/lists/#{personal.id}", params: { data: params } }
    context "with valid parameters" do
      let(:params) do
        {
          type: "lists",
          attributes: attributes_for(:personal, title: "My Personal List"),
        }
      end

      it "gets HTTP status 200" do
        expect(response.status).to eq 200
      end

      it "receives the updated resource" do
        expect(json_body["data"]["attributes"]["title"]).
          to eq "My Personal List"
      end

      it "updates the record in the database" do
        expect(List.first.title).to eq "My Personal List"
      end
    end

    context "with invalid parameters" do
      let(:params) do
        {
          attributes: { title: "" },
        }
      end

      it "gets HTTP status 422" do
        expect(response.status).to eq 422
      end

      it "receives error details" do
        expect(response.body).
          to have_jsonapi_errors_for("/data/attributes/title")
      end

      it "does not add a record in the database" do
        expect(List.first.title).to eq "Personal List"
      end
    end
  end

  describe "DELETE /api/v1/lists/:id" do
    context "with existing resource" do
      before { delete "/api/v1/lists/#{personal.id}" }

      it "gets HTTP status 204" do
        expect(response.status).to eq 204
      end

      it "deletes the book from the database" do
        expect(List.count).to eq 0
      end
    end

    context "with nonexistent resource" do
      it "gets HTTP status 404" do
        delete "/api/v1/lists/999999999"
        expect(response.status).to eq 404
      end
    end
  end
end
