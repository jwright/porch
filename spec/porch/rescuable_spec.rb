RSpec.describe Porch::Rescuable do
  class WeirdError < RuntimeError; end

  class ReallyScrewedUpClass
    include Porch::Rescuable

    attr_reader :result

    rescue_from WeirdError do |exception|
      @result = exception
    end

    def safely_raise_error(error)
      raise_error error
    rescue Exception => e
      rescue_with_handler(e) || raise(e)
    end

    def raise_error(error)
      raise error
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

  it "is called when the exception class matches" do
    subject.safely_raise_error WeirdError

    expect(subject.result).to be_kind_of WeirdError
  end

  it "is not called when the exception does not match" do
    expect { subject.safely_raise_error RuntimeError }.to raise_error RuntimeError
  end
end
