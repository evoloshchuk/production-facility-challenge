require_relative "flower"

class Design
  class SpecError < StandardError; end

  FLOWER_SPEC = /(?<flower quantity>\d+)(?<flower specie>[a-z])/
  private_constant :FLOWER_SPEC
  DESIGN_SPEC = /\A(?<design>[A-Z])(?<size>S|L)(?<flowers spec>(?:#{FLOWER_SPEC})+)(?<quantity>\d+)\z/
  private_constant :DESIGN_SPEC

  attr_reader :design, :size, :flowers, :quantity

  def initialize(spec)
    matched_data = spec.match(DESIGN_SPEC)
    raise(SpecError) if matched_data.nil?
    @design = matched_data["design"]
    @size = matched_data["size"]
    @quantity = matched_data["quantity"].to_i
    @flowers = parse_flowers_spec(matched_data["flowers spec"])
    flowers_quantity = @flowers.sum { |_flower, quantity| quantity }
    raise(SpecError) unless @quantity >= flowers_quantity
    @spec = spec
  rescue SpecError
    raise(SpecError, "Invalid design spec '#{spec}'")
  end

  def to_s
    @spec
  end

  def eql?(other)
    to_s == other.to_s
  end

  private

  def parse_flowers_spec(spec)
    matched_data = spec.scan(FLOWER_SPEC)
    flowers = {}
    matched_data.each do |flower_quantity, flower_specie|
      raise(SpecError) unless flower_quantity.to_i > 0
      raise(SpecError) if flowers.key?(flower_specie)
      flowers[flower_specie] = flower_quantity.to_i
    end
    flowers.map do |specie, quantity|
      [Flower.new("#{specie}#{size}"), quantity]
    end
  end
end
