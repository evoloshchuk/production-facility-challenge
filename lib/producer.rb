require_relative "storage"
require_relative "bouquet"

class Producer
  def initialize(designs)
    @designs = designs
    @storage = Storage.new
  end

  def consume(flower)
    @storage.put_flower(flower)
  end

  def produce
    design = smallest_produceable_design
    produce_bouquet(design) if design
  end

  private

  def smallest_produceable_design
    produceable_designs.sort_by(&:size).first
  end

  def produceable_designs
    @designs.select { |design| produceable?(design) }
  end

  def produceable?(design)
    return false unless @storage.has_sizes?(design.size, design.quantity)
    design.flowers.each do |flower, quantity|
      return false unless @storage.has_flowers?(flower, quantity)
    end
    true
  end

  def produce_bouquet(design)
    bouquet = Bouquet.new(design)

    design.flowers.each do |flower, quantity|
      quantity.times do
        bouquet.add(@storage.take_flower(flower))
      end
    end

    additional = design.quantity - bouquet.quantity
    additional.times do
      bouquet.add(@storage.take_flower_of_size(design.size))
    end

    bouquet
  end
end
