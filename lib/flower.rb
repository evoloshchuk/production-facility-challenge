class Flower
  class SpecError < StandardError; end

  SPEC = /\A(?<name>[a-z])(?<size>S|L)\z/
  private_constant :SPEC

  attr_reader :size, :name

  def initialize(spec)
    matched_data = spec.match(SPEC)
    raise(SpecError, "Invalid flower spec '#{spec}'") if matched_data.nil?
    @name = matched_data["name"]
    @size = matched_data["size"]
    @spec = spec
  end

  def to_s
    @spec
  end

  def eql?(other)
    to_s == other.to_s
  end
end
