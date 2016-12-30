RSpec.describe Porch::ExecutableStepDecorator do
  let(:organizer) { double(:organizer) }

  context "with a class step" do
    let(:step) { Object }
    subject { described_class.new step, organizer }

    it "decorates the step with a class decorator" do
      expect(subject.decorated_step).to \
        be_kind_of Porch::ClassStepDecorator
    end

    it "decorates a step" do
      expect(subject.step).to eq step
    end
  end

  context "with a method step" do
    let(:step) { :blah }
    subject { described_class.new step, organizer }

    it "decorates the step with a method decorator" do
      expect(subject.decorated_step).to \
        be_kind_of Porch::MethodStepDecorator
    end

    it "decorates a step" do
      expect(subject.step).to eq step
    end
  end

  context "with a proc step" do
    let(:step) { Proc.new { } }
    subject { described_class.new step, organizer }

    it "decorates the step with a proc decorator" do
      expect(subject.decorated_step).to \
        be_kind_of Porch::ProcStepDecorator
    end

    it "decorates a step" do
      expect(subject.step).to eq step
    end
  end

  context "with a step type that is not handled" do
    let(:step) { 1 }

    it "raises an InvalidStepTypeError" do
      expect { described_class.new(step, organizer) }.to \
        raise_error Porch::InvalidStepTypeError
    end
  end
end
