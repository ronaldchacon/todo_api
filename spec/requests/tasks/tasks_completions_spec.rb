RSpec.describe "Tasks::Completions", type: :request do
  include_context "Skip Auth"

  let(:list) { create(:list, user: user)}
  let(:task) { create(:task, list: list) }

  describe "PATCH /api/v1/tasks/:task_id/complete" do
    before do
      patch "/api/v1/tasks/#{task.id}/complete", params: { data: params }
    end

    context "with valid parameters" do
      let(:completed_at_time) { Time.current }
      let(:params) do
        {
          type: "tasks",
          attributes: {
            completed_at: completed_at_time,
          },
        }
      end

      it "gets HTTP status 200" do
        expect(response.status).to eq 200
      end

      it "receives the updated resource" do
        expect(json_body["data"]["attributes"]["title"]).
          to eq "Code project"
      end

      it "updates the record in the database" do
        expect(Task.first.completed_at).to be_within(1.second).
          of completed_at_time
      end
    end

    context "with invalid parameters" do
      let(:params) do
        {
          type: "tasks",
          attributes: {
            completed_at: "asdf",
          },
        }
      end

      it "gets HTTP status 422" do
        expect(response.status).to eq 422
      end

      it "receives error details" do
        expect(response.body).
          to have_jsonapi_errors_for("/data/attributes/completed_at")
      end

      it "does not update the record in the database" do
        expect(Task.first.completed_at).to eq nil
      end
    end
  end

  describe "PATCH /api/v1/tasks/:task_id/uncomplete" do
    before do
      patch "/api/v1/tasks/#{task.id}/uncomplete", params: { data: params }
    end

    context "with valid parameters" do
      let(:completed_at_time) { nil }
      let(:params) do
        {
          type: "tasks",
          attributes: {
            completed_at: completed_at_time,
          },
        }
      end

      it "gets HTTP status 200" do
        expect(response.status).to eq 200
      end

      it "receives the updated resource" do
        expect(json_body["data"]["attributes"]["completed_at"]).
          to eq nil
      end

      it "updates the record in the database" do
        expect(Task.first.completed_at).to eq nil
      end
    end

    context "with invalid parameters" do
      let(:list) { create(:list, user: user) }
      let(:task) { create(:task, list: list, completed_at: Time.current) }
      let(:params) do
        {
          type: "tasks",
          attributes: {
            completed_at: "asdf",
          },
        }
      end

      it "gets HTTP status 422" do
        expect(response.status).to eq 422
      end

      it "receives error details" do
        expect(response.body).
          to have_jsonapi_errors_for("/data/attributes/completed_at")
      end

      it "does not update the record in the database" do
        expect(Task.first.completed_at).to be_within(1.second).
          of Time.current
      end
    end
  end
end
