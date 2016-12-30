RSpec.describe Porch::Organizer do
  let(:dummy_class) { Class.new { include Porch::Organizer } }
  subject { dummy_class.new }

  it "adds a `with` instance method" do
    expect(subject).to respond_to(:with).with(1).argument
  end

  it "adds access to the context" do
    expect(subject).to respond_to(:context)
  end

  it "initializes with a nil context" do
    expect(subject.context).to be_nil
  end

  describe "#with" do
    it "returns the context" do
      expect(subject.with).to be_kind_of Porch::Context
    end

    context "without parameters and no steps" do
      it "returns an empty context" do
        expect(subject.with).to be_empty
      end
    end
  end
end
