# kvg_character_recognition_api
The API server for Kanji recognition using [kvg_character_recognition gem](https://github.com/thebluber/kvg_character_recognition)

## Usage

Setup and run server on port 9292
```ruby
$ git clone https://github.com/thebluber/kvg_character_recognition_api

$ bundle install

$ bundle exec rackup
```
Test the API
```ruby
$ curl -X POST -H "Content-Type: application/json" -d @strokes.json http://localhost:9292/api/v1/scores

=> {"scores":["二","匚","匸","工","冫","厂","汀","江","辶","冂"]}
```
