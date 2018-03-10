require_relative "../../lib/reader"
require_relative "../../lib/design"
require_relative "../../lib/flower"
require "stringio"

RSpec.describe Reader do
  context "valid input" do
    where(:input, :expected_designs, :expected_flowers) do
      [
        [
          "AL1a2b3\n",
          [Design.new("AL1a2b3")],
          []
        ],
        [
          "AL1a2b3\n\naS\n",
          [Design.new("AL1a2b3")],
          [Flower.new("aS")]
        ],
        [
          "AL1a2b3\nBS1a2b3c6\n\naS\nbL\n",
          [Design.new("AL1a2b3"), Design.new("BS1a2b3c6")],
          [Flower.new("aS"), Flower.new("bL")]
        ]
      ]
    end

    with_them do
      it "returns correct designs and flowers" do
        designs, flowers = described_class.read(StringIO.new(input))

        expect(designs).to eql(expected_designs)
        expect(flowers.to_a).to eql(expected_flowers)
      end
    end
  end
end
