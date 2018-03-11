require_relative "../../lib/flower"
require_relative "../../lib/bouquet"

RSpec.describe Bouquet do
  let(:bouquet) { described_class.new(name, size) }
  let(:name) { "A" }
  let(:size) { "L" }

  describe "#to_s" do
    subject { bouquet.to_s }

    where(:flowers, :expected_str) do
      [
        [[], "AL"],
        [["aL"], "AL1a"],
        [["aL", "aL"], "AL2a"],
        [["aL", "aL", "bL"], "AL2a1b"],
        [["cL", "bL", "aL"], "AL1a1b1c"]
      ]
    end

    with_them do
      before do
        flowers.each do |spec|
          bouquet.add(Flower.new(spec))
        end
      end
      it { is_expected.to eql(expected_str) }
    end
  end

  describe "#quantity" do
    subject { bouquet.quantity }

    where(:flowers, :expected_quantity) do
      [
        [[], 0],
        [["aL"], 1],
        [["aL", "aL"], 2],
        [["aL", "aL", "bL"], 3]
      ]
    end

    with_them do
      before do
        flowers.each do |spec|
          bouquet.add(Flower.new(spec))
        end
      end
      it { is_expected.to eql(expected_quantity) }
    end
  end
end
