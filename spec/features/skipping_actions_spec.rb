RSpec.describe "skipping actions" do
  class SkippingStepsExample
    include Porch::Organizer

    def run
      with do |chain|
        chain.add :first_step
        chain.add :second_step
      end
    end

    private

    def first_step(context)
      context.skip_remaining! true
      context[:got_here] = true
    end

    def second_step(context)
    end
  end

  subject { SkippingStepsExample.new }

  it "does not run actions after they were skipped" do
    expect(subject).to receive(:first_step).and_call_original
    expect(subject).to_not receive(:second_step)

    subject.run
  end

  it "returns a successful result" do
    expect(subject.run).to be_success
  end

  context "skipping the current step" do
    it "skips the remaining logic in the current step" do
      result = subject.run

      expect(result[:got_here]).to be_nil
    end
  end
end
