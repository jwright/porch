RSpec.describe "multiple step types within an organizer" do
  class SumAdditionStep
    def call(context)
      context[:sum] += 1
    end
  end

  class MultipleStepsExample
    include Porch::Organizer

    def run(arguments)
      with(arguments) do |chain|
        chain.add do |context|
          context[:sum] += 1
        end
        chain.add SumAdditionStep
        chain.add :sum_within_organizer
      end
    end

    private

    def sum_within_organizer(context)
      context[:sum] += 1
    end
  end

  it "simply returns a successful context" do
    subject = MultipleStepsExample.new

    result = subject.run(sum: 4)

    expect(result).to be_success
    expect(result[:sum]).to eq 7
  end
end
