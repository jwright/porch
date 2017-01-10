RSpec.describe "skipping current action" do
  class SkippingCurrentStepExample
    include Porch::Organizer

    def run
      with do |chain|
        chain.add :first_step
        chain.add :second_step
      end
    end

    private

    def first_step(context)
      context.next { required(:blah).filled }
      context[:got_here] = true
    end

    def second_step(context)
    end
  end

  subject { SkippingCurrentStepExample.new }

  it "skips the remaining logic in the current step" do
    result = subject.run

    expect(result[:got_here]).to be_nil
  end
end
