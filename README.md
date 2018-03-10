## Installation

```bash
docker-compose up app
```

## Usage

```bash
cat input.txt | docker-compose run --rm app bundle exec ruby app.rb
```

or

```bash
echo -ne "AL1a1\n\naL\n" | docker-compose run --rm app bundle exec ruby app.rb
```


## Test

```bash
docker-compose run --rm app bundle exec rspec
```
