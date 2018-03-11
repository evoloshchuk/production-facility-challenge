require_relative "../storage"
require_relative "../bouquet"

module Producer
  class Base
    def initialize(designs, capacity: nil)
      @designs = designs
      @capacity = capacity
      @storage = Storage.new(capacity: capacity)
    end

    def consume(flower)
      @storage.put(flower)
    end

    def produce(force: false)
      return if @capacity && !@storage.full? && !force
      design = select_design_to_produce
      produce_bouquet(design) if design
    end

    private

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
        bouquet.add(take_additional_flower_from_storage(design))
      end
    end
  end
end
