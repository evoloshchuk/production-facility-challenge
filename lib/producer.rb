require_relative "storage"
require_relative "bouquet"

class Producer
  def initialize(designs)
    @designs = designs
    @storage = Storage.new
  end

  def consume(flower)
    @storage.put(flower)
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
    return false unless @storage.count_sizes(design.size) >= design.quantity
    design.flowers.each do |flower, quantity|
      return false unless @storage.count_flowers(flower) >= quantity
    end
    true
  end

  def produce_bouquet(design)
    bouquet = Bouquet.new(design.name, design.size)
    add_required_flowers(bouquet, design)
    add_additional_flowers(bouquet, design)
    bouquet
  end

  def add_required_flowers(bouquet, design)
    design.flowers.each do |flower, quantity|
      quantity.times do
        bouquet.add(@storage.take(flower))
      end
    end
  end

  def add_additional_flowers(bouquet, design)
    additional = design.quantity - bouquet.quantity
    additional.times do
      bouquet.add(@storage.take_of_size(design.size))
    end
  end
end
