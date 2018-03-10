class Storage
  class OperationError < StandardError; end

  def initialize
    @line = {}
    @position = 0
    @flower_registry = Hash.new { |h, k| h[k] = [] }
    @size_counter = Hash.new(0)
  end

  def put_flower(flower)
    @line[@position] = flower
    @flower_registry[flower.to_s] << @position
    @size_counter[flower.size] += 1
    @position += 1
  end

  def take_flower(flower)
    position = @flower_registry[flower.to_s].shift
    raise(OperationError, "No such flower #{flower}") if position.nil?
    @line.delete(position)
    @size_counter[flower.size] -= 1
    flower
  end

  def take_flower_of_size(size)
    _position, flower = @line.find { |_position, flower| flower.size == size }
    take_flower(flower)
  end

  def has_flowers?(flower, quantity)
    @flower_registry[flower.to_s].size >= quantity
  end

  def has_sizes?(size, quantity)
    @size_counter[size] >= quantity
  end

  def to_s
    @line.values.join
  end
end
