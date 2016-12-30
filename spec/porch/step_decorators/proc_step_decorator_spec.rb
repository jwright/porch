RSpec.describe Porch::ProcStepDecorator do
  describe ".decorates?" do
    it "returns true if the step is a proc" do
      expect(described_class).to be_decorates Proc.new {}
    end

    it "returns true if the step is a lambda" do
      expect(described_class).to be_decorates lambda {}
    end

    it "returns false if the step is a class" do
      expect(described_class).to_not be_decorates Object
    end
  end

  describe "#execute" do
    let(:context) { Hash.new }
    let(:organizer) { double(:organizer) }
    let(:step) { Proc.new {} }
    subject { described_class.new step, organizer }

    it "calls the proc with the context" do
      expect(step).to receive(:call).with(context)

      subject.execute context
    end
  end
end
