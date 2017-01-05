RSpec.describe Porch::GuardRail do
  let(:dummy_class) { Class.new { include Porch::GuardRail } }
  subject { dummy_class.new }

  it "adds a `guard` instance method" do
    expect(subject).to respond_to(:guard)
  end

  describe "#guard" do
    let(:schema) { Proc.new { required(:email) }}

    it "returns the result of the validation" do
      expect(subject.guard(&schema)).to be_success
    end
  end
end
