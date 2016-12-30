RSpec.describe Porch::ClassStepDecorator do
  describe ".decorates?" do
    it "returns true if the step is a class" do
      expect(described_class).to be_decorates Object
    end

    it "returns false if the step is a symbol" do
      expect(described_class).to_not be_decorates :blah
    end

    it "returns false if the step is an instance of a class" do
      expect(described_class).to_not be_decorates Object.new
    end
  end

  describe "#execute" do
    class DummyClass
      def call(context)
      end
    end

    let(:context) { Hash.new }
    let(:step) { DummyClass }
    subject { described_class.new step }

    it "instantiates an instance of the object and sends call message with the context" do
      expect_any_instance_of(step).to receive(:call).with context

      subject.execute context
    end
  end
end
