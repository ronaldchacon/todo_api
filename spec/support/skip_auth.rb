RSpec.shared_context "Skip Auth" do
  let(:user) { create(:user, email: "user@foobar.com") }
  let(:access_token) { create(:access_token, user: user) }

  before do
    allow_any_instance_of(ApplicationController).
      to receive(:authenticate_user).and_return(true)
    allow_any_instance_of(ApplicationController).
      to receive(:access_token).and_return(access_token)
    allow_any_instance_of(ApplicationController).
      to receive(:current_user).and_return(user)
  end
end
