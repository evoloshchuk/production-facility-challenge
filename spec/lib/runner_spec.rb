require_relative "../../lib/runner"
require "stringio"

RSpec.describe Runner do
  subject { described_class }

  context "valid inputs" do
    where(:given_input, :expected_output) do
      [
        ["", ""],
        ["AL1a1", ""],
        ["AL1a1\n\naS", ""],
        ["AL1a1\n\nbL", ""],
        ["AL1a1\n\naS\naL", "AL1a\n"],
        ["AL1a1\n\naS\naL\nbL\naL", "AL1a\nAL1a\n"],
        ["AL1a2\n\naS\naL", ""],
        ["AL1a2\n\naS\naL\nbL", "AL1a1b\n"],
        ["AL1a2\n\naS\naL\nbL\naL\ncL", "AL1a1b\nAL1a1c\n"],
        ["AL1a1\nBL1a1b2\n\nbL\naL", "AL1a\n"],
        ["AL1a1b2\nBL1b1c1d3\n\ncL\ndL\naL\nbL", "AL1a1b\n"],
        ["AL1a1b2\nBL1b1c1d3\n\ncL\ndL\naL\nbL\nbL", "AL1a1b\nBL1b1c1d\n"]
      ]
    end

    with_them do
      it "produces correct output for the given input" do
        actual_output = StringIO.new
        subject.run(StringIO.new(given_input), actual_output)
        expect(actual_output.string).to eql(expected_output)
      end
    end
  end
end
