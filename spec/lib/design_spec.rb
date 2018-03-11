require_relative "../../lib/flower"
require_relative "../../lib/design"

RSpec.describe Design do
  subject { described_class.new(spec) }

  context "valid spec" do
    where(:spec, :name, :size, :quantity, :flowers) do
      [
        ["AL1a1",     "A", "L", 1, [["aL", 1]]],
        ["AL001a001", "A", "L", 1, [["aL", 1]]],
        ["BS1a2",     "B", "S", 2, [["aS", 1]]],
        ["BS2a2",     "B", "S", 2, [["aS", 2]]],
        ["CS1a2b3",   "C", "S", 3, [["aS", 1], ["bS", 2]]]
      ]
    end

    with_them do
      its(:name) { is_expected.to eql(name) }
      its(:size) { is_expected.to eql(size) }
      its(:quantity) { is_expected.to eql(quantity) }
      its(:flowers) {
        is_expected.to eql(flowers.map { |v| [Flower.new(v[0]), v[1]] })
      }
      its(:to_s) { is_expected.to eql(spec) }
    end
  end

  context "invalid spec" do
    where(:spec) do
      [
        "aL",
        "Al1a1",
        "AL0", # no flowers
        "AL1", # no flowers
        "AL2a1", # wrong total
        "AL1a2b2", # wrong total
        "AL0a0", # no 0 in spec
        "AL0a1", # no 0 in spec
        "AL1a2a3" # no repetitions in spec
      ]
    end

    with_them do
      it "raises an exception when instantiated" do
        expect { subject }.to raise_error(Design::SpecError)
      end
    end
  end
end
