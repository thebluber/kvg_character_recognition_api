require 'bundler'
require 'nokogiri'
require 'pry'
Bundler.require

API_DIR = File.expand_path('../app/api', __FILE__)

%w(defaults.rb version1.rb base.rb).each do |file|
  require "#{API_DIR}/#{file}"
end

module API
  DATASTORE = KvgCharacterRecognition::JSONDatastore.new('characters.json')
end
