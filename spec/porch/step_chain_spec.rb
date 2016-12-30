RSpec.describe Porch::StepChain do
  it "initializes with empty steps" do
    expect(subject.steps).to be_empty
  end

  describe "#add" do
    it "adds a step to the chain" do
      expect { subject.add :blah }.to change { subject.steps.count }.by 1
    end
  end

  describe "#insert" do
    it "adds a step to the specific index in the chain" do
      subject.add :bleh

      expect { subject.insert 0, :blah }.to change { subject.steps.count }.by 1
      expect(subject.steps.first.step).to eq :blah
    end
  end

  describe "#remove" do
    it "removes the step from the chain" do
      subject.add :blah
      subject.add :bleh

      expect { subject.remove :blah }.to change { subject.steps.count }.by -1
      expect(subject.steps.map(&:step)).to_not include :blah
      expect(subject.steps.map(&:step)).to include :bleh
    end
  end

  describe "#execute" do
    let(:context) { Hash.new }

    it "calls execute on each step" do
      subject.add :blah
      subject.add Proc.new {}

      expect_any_instance_of(Porch::MethodStepDecorator).to receive(:execute)
      expect_any_instance_of(Porch::ProcStepDecorator).to receive(:execute)

      subject.execute context
    end

    it "passes in a new instance of the context" do
      subject.add :blah

      result = subject.execute context

      expect(result).to_not equal context
    end
  end
end
