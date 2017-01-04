RSpec.describe "skipping the remaining steps within an organizer" do
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
      context.skip_remaining!
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
end
