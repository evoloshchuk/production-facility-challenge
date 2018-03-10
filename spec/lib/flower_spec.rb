require_relative "../../lib/flower"

RSpec.describe Flower do
  subject { described_class.new(spec) }

  context "valid spec" do
    where(:spec, :specie, :size) do
      [
        ["aL", "a", "L"],
        ["aS", "a", "S"],
        ["bL", "b", "L"],
        ["bS", "b", "S"]
      ]
    end

    with_them do
      its(:specie) { is_expected.to eql(specie) }
      its(:size) { is_expected.to eql(size) }
      its(:to_s) { is_expected.to eql(spec) }
    end
  end

  context "invalid spec" do
    where(:spec) do
      ["as", "al", "AL", "aW", "a"]
    end

    with_them do
      it "raises an exception when instantiated" do
        expect { subject }.to raise_error(Flower::SpecError)
      end
    end
  end
end
