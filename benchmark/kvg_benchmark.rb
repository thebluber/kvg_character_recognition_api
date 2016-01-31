require 'kvg_character_recognition'
require 'json'
module KvgCharacterRecognition
  class Benchmark
    attr_accessor :samples
    # +dir+:: "path_to_test_dir/"
    def initialize dir, recognizer
      @recognizer = recognizer
      @samples = Hash.new
      Dir.glob(dir + "**") do |file|
        next if File.directory? file
        input = JSON.parse(File.read(file), symbolize_names: true)
        @samples[input[:value]] ? @samples[input[:value]] << input[:strokes] : @samples[input[:value]] = [input[:strokes]]
      end
    end

    # This method benchmarks samples using given method and datastore
    # it stores the results in a log file
    # +datastore+:: a JSONDatastore
    # +method+:: method to be benchmarked as symbol i.e. :linkage_scores
    # +file+:: path to log file
    def benchmark datastore, file="benchmark_results"
      results = Hash.new
      log = File.open(file, "w")
      @samples.each_pair do |key, val|
        puts "Benchmarking for character #{key}"
        val.each do |strokes|
          print "."
          start_time = Time.now
          scores = @recognizer.scores(strokes, datastore)
          time = Time.now - start_time
          chr = KvgCharacterRecognition::Trainer::Character.new(strokes, nil)
          result = Result.new(scores, time, key, chr.number_of_points)
          results[key] ? results[key] << result : results[key] = [result]
        end
        print "\n"
        dump_results_for(key, results[key], log)
      end
      log.close
      results
    end

    def dump_results_for character, results, file
      file.puts "Benchmark results of #{character}"
      time_sum = 0
      score_sum = 0
      position_sum = 0
      top10 = 0
      points = 0
      file.puts "    position        score        time"
      file.puts "-------------------------------------"
      results.each_with_index do |result, i|
        time_sum += result.time
        score_sum += result.score
        position_sum += result.position
        top10 += 1 if result.position <= 10
        points += result.number_of_points
        file.puts "#{i+1}. #{result.position}     #{result.score}     #{result.time}    #{result.number_of_points}"
      end
      file.puts "-------------------------------------"
      file.puts "avg. #{position_sum / results.count}     #{(score_sum / results.count).round(2)}     #{(time_sum / results.count).round(2)}  #{(points / results.count).round(2)}"
      file.puts "Recognition Rate: #{(top10 / results.count.to_f) * 100}%"
      file.puts ""
    end
  end

  class Result
    attr_accessor :score, :position, :time, :number_of_points
    def initialize scores, time, input_character, number_of_points
      @time = time
      max = 0
      scores.each_with_index do |score_pair, i|
        max = score_pair[0] if score_pair[0] > max
        next if score_pair[1][:value] != input_character
        @score = score_pair[0]
        @position = i
        break
      end
      @score ||= max
      @position ||= scores.count + 1
      @number_of_points = number_of_points
    end
  end
end
