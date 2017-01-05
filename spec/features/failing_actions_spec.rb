RSpec.describe "failing actions" do
  class FailingStepsExample
    include Porch::Organizer

    def run
      with do |chain|
        chain.add :first_step
        chain.add :second_step
      end
    end

    private

    def first_step(context)
      context.fail!
      context[:got_here] = true
    end

    def second_step(context)
    end
  end

  subject { FailingStepsExample.new }

  it "does not run actions after the previous step fails" do
    expect(subject).to receive(:first_step).and_call_original
    expect(subject).to_not receive(:second_step)

    subject.run
  end

  it "returns a failed result" do
    expect(subject.run).to be_failure
  end

  it "fails the remaining logic in the current step" do
    result = subject.run

    expect(result[:got_here]).to be_nil
  end
end
