RSpec.describe "no steps within an organizer" do
  class NoStepsExample
    include Porch::Organizer

    def run(arguments)
      with(arguments)
    end
  end

  it "simply returns a successful context" do
    subject = NoStepsExample.new

    result = subject.run email: "test@example.com", password: "blah"

    expect(result[:email]).to eq "test@example.com"
  end
end
