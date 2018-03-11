require_relative "base"

module Producer
  class Rational < Base
    protected

    def select_design_to_produce
      produceable_design_with_minimum_addition_flowers
    end

    def take_additional_flower_from_storage(design)
      @storage.take(@storage.most_abundant_of_size(design.size))
    end

    private

    def produceable_design_with_minimum_addition_flowers
      produceable_designs.sort_by(&:additional_quantity).first
    end
  end
end
