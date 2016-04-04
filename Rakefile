require 'kvg_character_recognition'
require_relative 'benchmark/kvg_benchmark'
require 'pry'
require 'json'

task :init_datastore do
  KvgCharacterRecognition.init_datastore "characters.json", "kanjivg-20150615-2.xml"
end

task :init_joyo_kanji do
  datastore = KvgCharacterRecognition::JSONDatastore.new("joyo_kanji.json")
  joyo_kanji = File.read("joyo_kanji.txt").each_char.map.to_a
  KvgCharacterRecognition::Template.populate_from_xml "kanjivg-20150615-2.xml", datastore, joyo_kanji
end

task :benchmark do
  datastore = KvgCharacterRecognition::JSONDatastore.new("characters.json")
  b = KvgCharacterRecognition::Benchmark.new("benchmark/samples/", KvgCharacterRecognition::Recognizer)
  b.benchmark(datastore)
end

task :test do
  sample = JSON.parse(File.read('strokes.json'), symbolize_names: true)
  datastore = KvgCharacterRecognition::JSONDatastore.new("heatmaps_datastore.json")
  scores = KvgCharacterRecognition::Recognizer.scores(sample[:strokes], datastore).take(10)
  scores.each do |cand|
    puts "#{cand[1][:value]} #{cand[0]}"
  end
end
