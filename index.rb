require "json"
require "sinatra"
require "twitter"
require_relative "./lib/watson"
require_relative "./lib/text_analysis"
require_relative "./lib/db"
require_relative "./config"

$secondsInDay = 86400

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = $configuration[:twitter][:consumer_key]
  config.consumer_secret     = $configuration[:twitter][:consumer_secret]
  config.access_token        = $configuration[:twitter][:access_token]
  config.access_token_secret = $configuration[:twitter][:access_token_secret]
end

set :public_folder, File.dirname(__FILE__) + '/public'

get '/' do
  File.read(File.join('public', 'index.html'))
end

post '/tweets' do
  username = params['username']
  savedData = getTweetsFromDb(username)
  if savedData == nil
    begin
      tweets = client.user_timeline(username, count: 200)
      puts "Fetching Tweets at #{Time.now}"
    rescue Twitter::Error::NotFound
      return "#{username} not found"
    rescue Twitter::Error::Unauthorized
      return "#{username} has protected their tweets"
    end
    tweets = tweets.map{|t| t.text}
    File.write("./data/#{username}.json", JSON.dump({'tweets' => tweets, 'lastUpdated' => Time.now.to_i}))
  else
    tweets = savedData['tweets']
  end

  commonWordsArr = extractMostCommonWords(tweets.join(' '))
  response = translate(commonWordsArr)

  JSON.dump({
    'original' => commonWordsArr,
    'translations' => JSON.parse(response.body)['translations'].map{|t| t['translation']}
  })
end