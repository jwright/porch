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
end
