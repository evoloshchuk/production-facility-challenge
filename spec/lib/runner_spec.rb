require_relative "../../lib/runner"
require_relative "../../lib/producer/greedy"
require_relative "../../lib/producer/rational"
require "stringio"

RSpec.describe Runner do
  subject { described_class.new(producer_class) }

  context "valid input" do
    let(:r1) { described_class.new(Producer::Greedy) }
    let(:r2) { described_class.new(Producer::Greedy, 10) }
    let(:r3) { described_class.new(Producer::Rational) }
    let(:r4) { described_class.new(Producer::Rational, 10) }

    where(:input, :r1_output, :r2_output, :r3_output, :r4_output) do
      [
        ["", "", "", "", ""],
        ["AL1a1", "", "", "", ""],
        ["AL1a1\n\naS", "", "", "", ""],
        ["AL1a1\n\nbL", "", "", "", ""],
        ["AL1a2\n\naS\naL", "", "", "", ""],
        ["AL1a1\n\naS\naL", "AL1a\n", "AL1a\n", "AL1a\n", "AL1a\n"],
        ["AL1a2\n\naS\naL\nbL", "AL1a1b\n", "AL1a1b\n", "AL1a1b\n", "AL1a1b\n"],
        ["AL1a1\nBL1a1b2\n\nbL\naL", "AL1a\n", "AL1a\n", "AL1a\n", "AL1a\n"],
        [
          "AL1a1\n\naS\naL\nbL\naL",
          "AL1a\nAL1a\n",
          "AL1a\nAL1a\n",
          "AL1a\nAL1a\n",
          "AL1a\nAL1a\n"
        ],
        [
          "AL1a2\n\nbL\naL\ncL\naL\ncL",
          "AL1a1b\nAL1a1c\n",
          "AL1a1b\nAL1a1c\n",
          "AL1a1b\nAL1a1c\n",
          "AL1a1c\nAL1a1b\n"
        ],
        [
          "AL1a1b3\nBL1b1c1d3\n\ncL\ndL\naL\nbL",
          "AL1a1b1c\n",
          "AL1a1b1c\n",
          "BL1b1c1d\n",
          "BL1b1c1d\n"
        ],
      ]
    end

    with_them do
      it "Greedy produces correct output" do
        actual_output = StringIO.new
        r1.run(StringIO.new(input), actual_output)
        expect(actual_output.string).to eql(r1_output)
      end

      it "Greedy with limit produces correct output" do
        actual_output = StringIO.new
        r2.run(StringIO.new(input), actual_output)
        expect(actual_output.string).to eql(r2_output)
      end

      it "Rational produces correct output" do
        actual_output = StringIO.new
        r3.run(StringIO.new(input), actual_output)
        expect(actual_output.string).to eql(r3_output)
      end

      it "Rational with limit produces correct output" do
        actual_output = StringIO.new
        r4.run(StringIO.new(input), actual_output)
        expect(actual_output.string).to eql(r4_output)
      end
    end
  end
end
