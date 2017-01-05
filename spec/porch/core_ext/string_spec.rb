RSpec.describe Porch::CoreExt::String do
  describe "#initialize" do
    it "initializes with something that can be converted to a string" do
      expect(described_class.new(:blah)).to eq "blah"
    end
  end

  describe "#capitalize" do
    it "capitalizes the first word" do
      expect(described_class.new("hello world").capitalize.to_s).to eq "Hello world"
    end

    it "splits dasherize words" do
      expect(described_class.new("hello-world").capitalize.to_s).to eq "Hello world"
    end

    it "splits underscored words" do
      expect(described_class.new("hello_world").capitalize.to_s).to eq "Hello world"
    end

    it "downcases capitalized tail words" do
      expect(described_class.new("hello World").capitalize.to_s).to eq "Hello world"
    end

    it "splits capitalized words" do
      expect(described_class.new("helloWorld").capitalize.to_s).to eq "Hello world"
    end
  end
end
