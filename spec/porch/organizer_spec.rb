RSpec.describe Porch::Organizer do
  let(:dummy_class) { Class.new { include Porch::Organizer } }
  subject { dummy_class.new }

  it "adds a `with` instance method" do
    expect(subject).to respond_to(:with).with(1).argument
  end

  it "adds a `rescue_from` class method" do
    expect(subject.class).to respond_to(:rescue_from)
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

    it "returns an empty context" do
      expect(subject.with).to be_empty
    end

    it "yields to a block chain if specified" do
      expect { |b| subject.with(&b) }.to yield_with_args(Porch::StepChain)
    end

    it "executes the chain with the context" do
      expect_any_instance_of(Porch::StepChain).to \
        receive(:execute).with(Porch::Context)

      subject.with
    end
  end

  describe ".rescue_from" do
    class DoSomething
      include Porch::Organizer

      attr_reader :result

      rescue_from RuntimeError do |exception|
        @result = exception
      end

      def process
        with do |chain|
          chain.add :do_something_funky
        end
      end

      private

      def do_something_funky(context)
        raise RuntimeError
      end
    end

    subject { DoSomething.new }

    it "handles errors that come from any of the steps" do
      expect { subject.process }.to_not raise_error
      expect(subject.result).to be_kind_of RuntimeError
    end
  end
end
