RSpec.describe Porch::Context do
  describe "#initialize" do
    it "can be initialized with a hash" do
      subject = described_class.new({ a: :b, c: :d })

      expect(subject.keys).to eq [:a, :c]
      expect(subject.values).to eq [:b, :d]
    end

    it "initializes as successful" do
      expect(subject).to be_success
    end

    it "initializes with a nil message" do
      expect(subject.message).to be_nil
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
      subject = described_class.new

      result = subject.deep_dup

      expect(subject).to_not equal result
    end

    it "copies the hash keys and values" do
      subject = described_class.new({ a: :b, c: :d })

      result = subject.deep_dup

      expect(subject).to eq result
      expect(result.keys).to eq [:a, :c]
    end

    it "copies the successful indicator" do
      subject = described_class.new({}, false)

      result = subject.deep_dup

      expect(result).to be_failure
    end
  end

  describe "#fail!" do
    subject { described_class.new({}, true) }

    it "marks the context as failed" do
      subject.fail!

      expect(subject).to be_failure
    end

    context "failing with a message" do
      it "sets the message on the context" do
        subject.fail! "Better luck next time!"

        expect(subject.message).to eq "Better luck next time!"
      end
    end
  end

  describe "#guard!" do
    subject { described_class.new({email: ""}) }

    context "with invalid arguments" do
      it "marks the context as a failure" do
        subject.guard! { required(:email).filled }

        expect(subject).to be_failure
      end

      it "sets the message of the context" do
        subject.guard! { required(:email).filled }

        expect(subject.message).to eq "Email must be filled"
      end
    end
  end

  describe "#method_missing" do
    subject { described_class.new blah: :bleh }

    it "returns a key value if the method name is in the context" do
      expect(subject.blah).to eq :bleh
    end

    it "raises a no method error found if the method name is not in the context" do
      expect { subject.bleh }.to raise_error NoMethodError
    end
  end

  describe "#stop_processing?" do
    subject { described_class.new({}, true) }

    it "stops when a failure occurs" do
      subject.fail!

      expect(subject).to be_stop_processing
    end
  end
end
