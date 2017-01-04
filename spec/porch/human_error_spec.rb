RSpec.describe Porch::HumanError do
  describe "#message" do
    context "with one error" do
      let(:errors) { { email: ["is required"] }}

      it "returns the single error" do
        expect(described_class.new(errors).message).to eq "Email is required"
      end
    end

    context "with two errors for one attribute" do
      let(:errors) { { email: ["is required", "is invalid"] }}

      it "returns both errors seperated by a comma" do
        expect(described_class.new(errors).message).to \
          eq "Email is required, Email is invalid"
      end
    end

    context "with errors on two attributes" do
      let(:errors) { { email: ["is invalid"], name: ["is required"] }}

      it "returns both errors seperated by a comma" do
        expect(described_class.new(errors).message).to \
          eq "Email is invalid, Name is required"
      end
    end

    context "with nested errors" do
      let(:errors) { { address: { city: ["is required"] }}}

      it "returns the error description concatenated" do
        expect(described_class.new(errors).message).to eq "Address city is required"
      end
    end

    context "with two nested errors" do
      let(:errors) do
        { address: { city: ["is required"] },
          profile: { email: ["is invalid", "is required"] }}
      end

      it "returns the error description concatenated" do
        expect(described_class.new(errors).message).to eq \
          "Address city is required, Profile email is invalid, Profile email is required"
      end
    end
  end
end
