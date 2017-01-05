RSpec.describe Porch::GuardRail::Guard do
  describe "#initialize" do
    let(:hash) { { blah: :bleh } }

    it "initializes with an object to guard against" do
      expect(described_class.new(hash).guarded_object).to eq hash
    end
  end

  describe "#against" do
    let(:schema) { Proc.new { required(:email, :string).filled } }

    context "with a valid schema" do
      let(:hash) { { email: "test@example.com" } }
      subject { described_class.new hash }

      it "is successful" do
        expect(subject.against(&schema)).to be_success
      end
    end

    context "with an invalid schema" do
      let(:hash) { { email: "" } }
      subject { described_class.new hash }

      it "is a failure" do
        expect(subject.against(&schema)).to be_failure
      end

      it "contains the errors" do
        expect(subject.against(&schema).messages).to eq({ email: ["must be filled"] })
      end
    end
  end
end
