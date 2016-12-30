RSpec.shared_context "Skip Auth" do
  before do
    allow_any_instance_of(ApplicationController).
      to receive(:authenticate_user).and_return(true)
  end
end
