class Bouquet
  class SpecError < StandardError; end

  def initialize(design)
    @design = design
    @registry = Hash.new(0)
  end

  def quantity
    @registry.values.sum
  end

  def add(flower)
    @registry[flower.specie] += 1
  end

  def to_s
    spec = @registry.sort.map { |specie, quantity| "#{quantity}#{specie}" }.join
    "#{@design.design}#{@design.size}#{spec}"
  end

  def eql?(other)
    to_s == other.to_s
  end
end
