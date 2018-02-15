require_relative "./common_words"

def extractMostCommonWords(text, blacklist=STOP_WORDS)
  text = text.downcase.split(' ')
  STOP_WORDS.each{|w| text.delete(w)}
  
  # Remove hashtags, mentions, urls
  text = text.keep_if do |w|
    w.length > 5 &&
    !(w.start_with?('#') || w.start_with?('@') || w.start_with?('http'))
  end

  freq = Hash.new(0)
  text.each{|w| freq[w] += 1}
  arr = []
  freq.each{|k, v| arr.push({:total => v, :word => k})}
  sorted = arr.sort_by{|h| h[:total]}
  sorted[sorted.length - 20, sorted.length].map{|h| h[:word]}
end