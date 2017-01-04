RSpec.describe Porch::GuardRail do
  let(:dummy_class) { Class.new { include Porch::GuardRail } }
  subject { dummy_class.new }

  it "adds a `guard` instance method" do
    expect(subject).to respond_to(:guard)
  end

  it "adds a `guard!` instance method" do
    expect(subject).to respond_to(:guard!)
  end
end
