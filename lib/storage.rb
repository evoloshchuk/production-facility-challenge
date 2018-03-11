class Storage
  class OperationError < StandardError; end

  def initialize(capacity=nil)
    @capacity = capacity
    @line = {}
    @position = 0
    @registry = Hash.new do |h, flower_size|
      h[flower_size] = Hash.new do |h, flower_spec|
        h[flower_spec] = [] # positions on the line
      end
    end
  end

  def full?
    !@capacity.nil? && @capacity <= @line.size
  end

  def put(flower)
    raise(OperationError, "Storage is full, no place fo #{flower}") if full?
    @line[@position] = flower
    @registry[flower.size][flower.to_s] << @position
    @position += 1
  end

  def take(flower)
    position = @registry[flower.size][flower.to_s].shift
    raise(OperationError, "No such flower #{flower}") if position.nil?
    @line.delete(position)
    flower
  end

  def first_of_size(size)
    _position, flower = @line.find { |_position, flower| flower.size == size }
    flower
  end

  def prevalent_of_size(size)
    _flower, positions = @registry[size]
      .sort_by { |spec, positions| -positions.size }
      .first
    @line[positions.first] if positions
  end

  def count_flowers(flower)
    @registry[flower.size][flower.to_s].size
  end

  def count_sizes(size)
    @registry[size].values.flatten.size
  end

  def to_s
    @line.values.join
  end
end
