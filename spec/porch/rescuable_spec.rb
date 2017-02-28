RSpec.describe Porch::Rescuable do
  class WeirdError < RuntimeError; end
  class MethodError < RuntimeError; end
  class ParentError < NotImplementedError; end

  class ReallyScrewedUpClass
    include Porch::Rescuable

    attr_reader :result

    rescue_from MethodError, with: :method_handler
    rescue_from WeirdError, NotImplementedError do |exception|
      @result = exception
    end

    def safely_raise_error(error)
      handle_exceptions do
        raise_error error
      end
    end

    def raise_error(error)
      raise error
    end

    private

    def method_handler(exception)
      @result = exception
    end
  end

  subject { ReallyScrewedUpClass.new }

  it "adds a `rescue_from` class method" do
    expect(subject.class).to respond_to(:rescue_from)
  end

  it "handles the error" do
    expect { subject.safely_raise_error WeirdError }.to_not raise_error
  end

  it "raises an exception if a method name or proc are not provided" do
    expect { subject.class.rescue_from RuntimeError }.to raise_error ArgumentError
  end

  context "with a block" do
    it "is called when the exception class matches" do
      subject.safely_raise_error WeirdError

      expect(subject.result).to be_kind_of WeirdError
    end
  end

  context "with a method" do
    it "is called when the exception class matches" do
      subject.safely_raise_error MethodError

      expect(subject.result).to be_kind_of MethodError
    end
  end

  it "is not called when the exception does not match" do
    expect { subject.safely_raise_error RuntimeError }.to raise_error RuntimeError
  end

  it "is called when the error is a descendant of the raised exception" do
    subject.safely_raise_error ParentError

    expect(subject.result).to be_kind_of NotImplementedError
  end
end
