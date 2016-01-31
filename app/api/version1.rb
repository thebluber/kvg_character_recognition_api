module API
  class Version1 < Grape::API
    include API::Defaults
    version 'v1'

    desc 'Return scores calculated for given input strokes'
    params do
      requires :strokes, type: String
      requires :n_best, type: Integer
    end
    post 'scores' do
      strokes = JSON.parse(params[:strokes])

      start = Time.now
      scores = KvgCharacterRecognition::Recognizer.scores(strokes, DATASTORE).take params[:n_best]

      { scores: scores.map{ |score| score.last[:value] }, time: Time.now - start }
    end

    desc 'Save samples'
    params do
      requires :sample, type: String
    end
    post 'save' do
      error = nil
      begin
        JSON.parse(params[:sample])
        file = File.open("test_samples/#{Time.now.hash.to_s(16).gsub("-", "")}", "w")
        file.puts params[:sample]
        file.close
      rescue
        error = "Can not parse json file!"
      end

      error ? { notice: error } : { notice: "Sample saved!" }
    end
  end
end
