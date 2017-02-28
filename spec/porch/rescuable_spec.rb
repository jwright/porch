RSpec.describe Porch::Rescuable do
  let(:dummy_class) { Class.new { include Porch::Rescuable } }
  subject { dummy_class.new }

  it "adds a `rescue_from` class method" do
    expect(subject.class).to respond_to(:rescue_from)
  end
end
