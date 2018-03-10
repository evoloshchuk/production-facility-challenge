require_relative "reader"
require_relative "producer"

class Runner
  def self.run(input_io, ouput_io)
    designs, flowers_enum = Reader.read(input_io)

    producer = Producer.new(designs)

    flowers_enum.each do |flower|
      producer.consume(flower)

      while (bouquet = producer.produce)
        ouput_io.puts(bouquet)
      end
    end
  end
end
