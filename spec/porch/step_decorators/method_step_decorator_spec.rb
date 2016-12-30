RSpec.describe Porch::MethodStepDecorator do
  describe ".decorates?" do
    it "returns true if the step is a symbol" do
      expect(described_class).to be_decorates :blah
    end

    it "returns true if the step is a string" do
      expect(described_class).to be_decorates "blah"
    end

    it "returns false if the step is a class" do
      expect(described_class).to_not be_decorates Object
    end

    it "returns false if the step is an instance of an object" do
      expect(described_class).to_not be_decorates Object.new
    end
  end
end
