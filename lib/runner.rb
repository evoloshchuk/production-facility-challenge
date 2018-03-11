require_relative "reader"

class Runner
  def initialize(producer_class, capacity=nil)
    @producer_class = producer_class
    @capacity = capacity
  end

  def run(input_io, ouput_io)
    designs, flowers_enum = Reader.read(input_io)

    producer = @producer_class.new(designs, capacity: @capacity)

    flowers_enum.each do |flower|
      producer.consume(flower)

      while (bouquet = producer.produce)
        ouput_io.puts(bouquet)
      end
    end

    while (bouquet = producer.produce(force: true))
      ouput_io.puts(bouquet)
    end
  end
end
