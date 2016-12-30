RSpec.describe Porch::ExecutableStepDecorator do
  context "with a class step" do
    let(:step) { Object }

    it "decorates the step with a class decorator" do
      expect(described_class.new(step).decorated_step).to \
        be_kind_of Porch::ClassStepDecorator
    end

    it "decorates a step" do
      expect(described_class.new(step).step).to eq step
    end
  end

  context "with a method step" do
    let(:step) { :blah }

    it "decorates the step with a method decorator" do
      expect(described_class.new(step).decorated_step).to \
        be_kind_of Porch::MethodStepDecorator
    end

    it "decorates a step" do
      expect(described_class.new(step).step).to eq step
    end
  end

  context "with a proc step" do
    let(:step) { Proc.new { } }

    it "decorates the step with a proc decorator" do
      expect(described_class.new(step).decorated_step).to \
        be_kind_of Porch::ProcStepDecorator
    end

    it "decorates a step" do
      expect(described_class.new(step).step).to eq step
    end
  end
end
