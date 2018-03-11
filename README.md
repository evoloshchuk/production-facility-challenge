## Solution
The solution has 2 modes of producing bouquets and 2 simple strategies for assembling bouquets.
##### Modes
* _Without storage capacity restriction_ - to start producing bouquets as soon as possible.
* _With storage capacity restriction_ - to start producing bouquets only when storage is full (which allows for a more sophisticated strategies to assemble bouquets).
##### Strategies
Strategy defines 2 important choices:
1. How to select a design to be produced?
2. How to select the additional (not fixed) flowers for a bouquet?

Available strategies:
* _Greedy_ - to select the smallest possible design and take the first suitable flowers as additional.
* _Rational_ - to select the design with the minimum additional (not fixed) flowers needed and takes the prevalent suitable flowers as additional.


## Installation

```bash
docker-compose up app
```

## Usage

```bash
cat input.txt | docker-compose run --rm app bundle exec ruby app.rb greedy
cat input.txt | docker-compose run --rm app bundle exec ruby app.rb greedy 256
cat input.txt | docker-compose run --rm app bundle exec ruby app.rb rational
cat input.txt | docker-compose run --rm app bundle exec ruby app.rb rational 256
```

or

```bash
echo -ne "AL1a1\n\naL\n" | docker-compose run --rm app bundle exec ruby app.rb greedy
echo -ne "AL1a1\n\naL\n" | docker-compose run --rm app bundle exec ruby app.rb greedy 256
echo -ne "AL1a1\n\naL\n" | docker-compose run --rm app bundle exec ruby app.rb rational 256
echo -ne "AL1a1\n\naL\n" | docker-compose run --rm app bundle exec ruby app.rb rational 256
```

## Test

```bash
docker-compose run --rm app bundle exec rspec
```
