RSpec.describe "Tasks", type: :request do
  let(:personal) { create(:personal) }
  let(:task1) { create(:task, title: "Task One", list: personal) }
  let(:task2) { create(:task, title: "Task Two", list: personal) }
  let(:task3) { create(:task, title: "Task Three", list: personal) }
  let(:tasks) { [task1, task2, task3] }

  describe "GET /api/v1/lists/:list_id/tasks" do
    before { tasks }

    context "default behavior" do
      before { get "/api/v1/lists/#{personal.id}/tasks" }

      it "gets HTTP status 200" do
        expect(response).to have_http_status(200)
      end

      it 'receives a json with the "data" root key' do
        expect(json_body["data"]).to_not be nil
      end

      it "receives all 3 tasks" do
        expect(json_body["data"].size).to eq 3
      end
    end

    describe "pagination" do
      context "when asking for the first page" do
        before do
          get "/api/v1/lists/#{personal.id}/tasks?page[number]=1&page[size]=2"
        end

        it "receives HTTP status 200" do
          expect(response.status).to eq 200
        end

        it "receives only two tasks" do
          expect(json_body["data"].size).to eq 2
        end

        it 'receives links object with "next" link' do
          expected = "http://www.example.com/api/v1/lists/#{personal.id}/tasks?page[number]=2&page[size]=2"
          expect(URI.unescape(json_body["links"]["next"])).to eq expected
        end
      end

      context "when asking for the second page" do
        before do
          get "/api/v1/lists/#{personal.id}/tasks?page[number]=2&page[size]=2"
        end

        it "receives HTTP status 200" do
          expect(response.status).to eq 200
        end

        it "receives only one task" do
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
        it 'sorts the tasks by "id desc"' do
          get("/api/v1/lists/#{personal.id}/tasks?sort=id&dir=desc")
          expect(json_body["data"].first["id"].to_i).
            to eq personal.tasks.last.id
          expect(json_body["data"].last["id"].to_i).
            to eq personal.tasks.first.id
        end
      end

      context 'with invalid column name "fid"' do
        before { get "/api/v1/lists/#{personal.id}/tasks?sort=fid&dir=asc" }

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
      context 'with valid filtering param "q[title_cont]=Task One"' do
        it 'receives "Task One" back' do
          get("/api/v1/lists/#{personal.id}/tasks?q[title_cont]=Task One")
          expect(json_body["data"].first["id"].to_i).to eq task1.id
          expect(json_body["data"].size).to eq 1
        end
      end

      context 'with invalid filtering param "q[ftitle_cont]=Task One"' do
        before { get("/api/v1/lists?q[ftitle_cont]=Task One") }
        it 'gets "400 Bad Request" back' do
          expect(response.status).to eq 400
        end

        it "receives an error" do
          expect(json_body["error"]).to_not be nil
        end

        it 'receives "q[ftitle_cont]=Task One" as an invalid param' do
          expect(json_body["error"]["invalid_params"]).to eq "q[ftitle_cont]=Task One"
        end
      end
    end
  end

  describe "GET /api/v1/lists/:list_id/tasks/:id" do
    context "with existing resource" do
      before { get "/api/v1/lists/#{personal.id}/tasks/#{task1.id}" }
      it "gets HTTP status 200" do
        expect(response.status).to eq 200
      end

      it 'receives "task1" as JSON' do
        expect(json_body["data"]["id"]).to eq task1.id.to_s
      end
    end

    context "with nonexistent resource" do
      it "gets HTTP status 404" do
        get "/api/v1/lists/999999999/tasks/999999999"
        expect(response.status).to eq 404
      end
    end
  end

  describe "POST /api/v1/lists/:list_id/tasks" do
    before do
      post "/api/v1/lists/#{personal.id}/tasks", params: { data: params }
    end

    context "with valid parameters" do
      let(:params) do
        {
          type: "tasks",
          attributes: attributes_for(:task),
        }
      end

      it "gets HTTP status 201" do
        expect(response.status).to eq 201
      end

      it "receives the newly created resource" do
        expect(json_body["data"]["attributes"]["title"]).to eq "Code project"
        expect(json_body["data"]["attributes"]["description"]).
          to eq "Need to implement..."
      end

      it "adds a record in the database" do
        expect(Task.count).to eq 1
      end

      it "gets the new resource location in the Location header" do
        expect(response.headers["Location"]).to eq(
          "http://www.example.com/api/v1/lists/#{personal.id}/tasks/#{Task.first.id}",
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
        expect(Task.count).to eq 0
      end
    end
  end

  describe "PATCH /api/v1/lists/:list_id/tasks/:id" do
    before do
      patch "/api/v1/lists/#{personal.id}/tasks/#{task1.id}",
            params: { data: params }
    end

    context "with valid parameters" do
      let(:params) do
        {
          type: "tasks",
          attributes: attributes_for(:task, title: "Finish project"),
        }
      end

      it "gets HTTP status 200" do
        expect(response.status).to eq 200
      end

      it "receives the updated resource" do
        expect(json_body["data"]["attributes"]["title"]).
          to eq "Finish project"
      end

      it "updates the record in the database" do
        expect(Task.first.title).to eq "Finish project"
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
        expect(Task.first.title).to eq "Task One"
      end
    end
  end

  describe "DELETE /api/v1/lists/:list_id/tasks/:id" do
    context "with existing resource" do
      before { delete "/api/v1/lists/#{personal.id}/tasks/#{task1.id}" }

      it "gets HTTP status 204" do
        expect(response.status).to eq 204
      end

      it "deletes the book from the database" do
        expect(Task.count).to eq 0
      end
    end

    context "with nonexistent resource" do
      it "gets HTTP status 404" do
        delete "/api/v1/lists/999999999/tasks/999999999"
        expect(response.status).to eq 404
      end
    end
  end
end
