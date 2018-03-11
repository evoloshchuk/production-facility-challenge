require_relative "base"

module Producer
  class Greedy < Base
    protected

    def select_design_to_produce
      smallest_produceable_design
    end

    def take_additional_flower_from_storage(design)
      @storage.take_first_of_size(design.size)
    end

    private

    def smallest_produceable_design
      produceable_designs.sort_by(&:quantity).first
    end
  end
end
