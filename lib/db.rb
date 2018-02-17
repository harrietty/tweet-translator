def getTweetsFromDb(username)
  dataPath = File.join(File.dirname(__FILE__), '..', 'data')
  if !Dir.entries(dataPath).include? "#{username}.json" then return nil end
  data = JSON.parse(File.read("#{dataPath}/#{username}.json"))
  if Time.now.to_i - data['lastUpdated'] > $secondsInDay then return nil end
  data
end
