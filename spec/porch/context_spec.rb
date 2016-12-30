RSpec.describe Porch::Context do
  describe "#initialize" do
    it "can be initialized with a hash" do
      subject = described_class.new({ a: :b, c: :d })

      expect(subject.keys).to eq [:a, :c]
      expect(subject.values).to eq [:b, :d]
    end

    it "can handle a nil context" do
      subject = described_class.new nil

      expect(subject).to be_empty
    end

    context "with a nested hash" do
      it "copies the nested hash" do
        subject = described_class.new({ a: { b: { c: :d }}})

        expect(subject.keys).to eq [:a]
        expect(subject.values).to eq [b: { c: :d }]
      end
    end
  end

  describe "#deep_dup" do
    it "copies the object into a new object" do
      context = described_class.new

      result = context.deep_dup

      expect(context).to_not equal result
    end

    it "copies the hash keys and values" do
      context = described_class.new({ a: :b, c: :d })

      result = context.deep_dup

      expect(context).to eq result
      expect(result.keys).to eq [:a, :c]
    end
  end
end
