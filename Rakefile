require 'nokogiri'
require 'measurable'
require 'kvg_character_recognition'
require_relative 'benchmark/kvg_benchmark'
require 'pry'

task :init_datastore do
  datastore = KvgCharacterRecognition::JSONDatastore.new("characters.json")
  KvgCharacterRecognition::Trainer.populate_from_xml "kanjivg-20150615-2.xml", datastore
end

task :init_joyo_kanji do
  datastore = KvgCharacterRecognition::JSONDatastore.new("joyo_kanji.json")
  joyo_kanji = File.read("joyo_kanji.txt").each_char.map.to_a
  KvgCharacterRecognition::Trainer.populate_from_xml "kanjivg-20150615-2.xml", datastore, joyo_kanji
end

task :benchmark do
  datastore = KvgCharacterRecognition::JSONDatastore.new("characters.json")
  b = KvgCharacterRecognition::Benchmark.new("benchmark/samples/", KvgCharacterRecognition::Recognizer)
  b.benchmark(datastore)
end
