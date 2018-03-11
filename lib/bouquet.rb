class Bouquet
  def initialize(name, size)
    @name = name
    @size = size
    @registry = Hash.new(0)
  end

  def add(flower)
    @registry[flower.name] += 1
  end

  def to_s
    spec = @registry.sort.map { |name, quantity| "#{quantity}#{name}" }.join
    "#{@name}#{@size}#{spec}"
  end
end
