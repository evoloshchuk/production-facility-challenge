require_relative "design"
require_relative "flower"

class Reader
  class << self
    def read(io)
      design_specs, flower_specs_enum = read_specs(io)

      designs = design_specs.map { |design_spec| Design.new(design_spec) }

      flowers_enum = Enumerator.new do |y|
        flower_specs_enum.each do |flower_spec|
          y.yield Flower.new(flower_spec)
        end
      end

      [designs, flowers_enum]
    end

    private

    def read_specs(io)
      design_specs = []
      while !io.eof && (spec = io.readline) != "\n"
        design_specs << spec.strip
      end

      flower_specs_enum = Enumerator.new do |y|
        while !io.eof && (spec = io.readline) != "\n"
          y.yield spec.strip
        end
      end

      [design_specs, flower_specs_enum]
    end
  end
end
