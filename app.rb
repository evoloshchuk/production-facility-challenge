# Usage:
# - to run algorithm without storage capacity restrictions:
#   $ ruby app.rb greedy
#   $ ruby app.rb rational
# - to run algorithm with storage capacity restrictions:
#   $ ruby app.rb greedy 256
#   $ ruby app.rb rational 256

require_relative "lib/runner"
require_relative "lib/producer/greedy"
require_relative "lib/producer/rational"

strategy = ARGV[0]
STRATEGIES = { "greedy" => Producer::Greedy, "rational" => Producer::Rational }
producer_class = STRATEGIES.fetch(strategy)
capacity = ARGV[1].to_i if ARGV[1]

runner = Runner.new(producer_class, capacity)
runner.run(STDIN, STDOUT)
