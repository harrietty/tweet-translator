require "sinatra"
require "twitter"

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "jMLQd1injxviHl9wtYL19tT2f"
  config.consumer_secret     = "OPcJfrbprNnaiYlQ79rUTOMgDh6k0fcLdur8cMzMl8NzphsZKh"
  config.access_token        = "1632499316-pWw1g0nJidUCg7vUK7RDix9tCv0cYxsjGfhlEnn"
  config.access_token_secret = "B4d1LvvBcg4UoFbmOmpW2V672B0VpBQeRjIdC1kG2KP1s"
end

set :public_folder, File.dirname(__FILE__) + '/public'

get '/' do
  File.read(File.join('public', 'index.html'))
end

post '/tweets' do
  username = params['username']
  begin
    tweets = client.user_timeline(username, count: 50)
  rescue Twitter::Error::NotFound
    return "#{username} not found"
  rescue Twitter::Error::Unauthorized
    return "#{username} has protected their tweets"
  end

  tweets.map{|t| t.text}
end