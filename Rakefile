require 'nokogiri'
require 'measurable'
require 'kvg_character_recognition'
require_relative 'benchmark/kvg_benchmark'
require 'pry'

task :init_datastore do
  datastore = KvgCharacterRecognition::JSONDatastore.new("characters.json")
  KvgCharacterRecognition::Trainer.populate_from_xml "kanjivg-20150615-2.xml", datastore
end

task :benchmark do
  datastore = KvgCharacterRecognition::JSONDatastore.new("characters.json")
  b = KvgCharacterRecognition::Benchmark.new("benchmark/samples/", KvgCharacterRecognition::Recognizer)
  b.benchmark(datastore)
end
