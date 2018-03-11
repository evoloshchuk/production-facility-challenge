require_relative "flower"

class Design
  class SpecError < StandardError; end

  FLOWER_SPEC = /(?<flower_quantity>\d+)(?<flower_name>[a-z])/
  private_constant :FLOWER_SPEC

  DESIGN_SPEC = /
    \A
    (?<name>[A-Z])
    (?<size>S|L)
    (?<flowers spec>(?:#{FLOWER_SPEC})+)
    (?<quantity>\d+)
    \z
  /x
  private_constant :DESIGN_SPEC

  attr_reader :name, :size, :flowers, :quantity

  def initialize(spec)
    matched_data = spec.match(DESIGN_SPEC)
    raise(SpecError) if matched_data.nil?
    @name = matched_data["name"]
    @size = matched_data["size"]
    @quantity = matched_data["quantity"].to_i
    @flowers = parse_flowers_spec(matched_data["flowers spec"])
    @spec = spec
    validate_quantities
  rescue SpecError
    raise(SpecError, "Invalid design spec '#{spec}'")
  end

  def to_s
    @spec
  end

  def eql?(other)
    to_s == other.to_s
  end

  def additional_quantity
    @quantity - fixed_quantity
  end

  private

  def fixed_quantity
    @flowers.sum { |_flower, quantity| quantity }
  end

  def parse_flowers_spec(spec)
    matched_data = spec.scan(FLOWER_SPEC)
    validate_positive_quantity(matched_data)
    validate_uniq_names(matched_data)
    matched_data.map do |quantity, name|
      [Flower.new("#{name}#{@size}"), quantity.to_i]
    end
  end

  def validate_positive_quantity(matched_data)
    quantities = matched_data.map { |quantity, _name| quantity.to_i }
    raise(SpecError) unless quantities.all? { |quantity| quantity > 0 }
  end

  def validate_uniq_names(matched_data)
    names = matched_data.map { |_quantity, name| name }
    raise(SpecError) unless names.size == names.uniq.size
  end

  def validate_quantities
    raise(SpecError) unless @quantity >= fixed_quantity
  end
end
