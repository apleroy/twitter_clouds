module ApplicationHelper

  #MOVE TO INITIALIZER?? / SERVICE??
  $twitter_client = Twitter::REST::Client.new do |config|
    config.consumer_key = ENV['TWITTER_KEY']
    config.consumer_secret = ENV['TWITTER_SECRET']
  end

  def $twitter_client.get_all_tweets(user)
    collect_with_max_id do |max_id|
      options = {count: 200, include_rts: true}
      options[:max_id] = max_id unless max_id.nil?
      user_timeline(user, options)
    end
  end

  def collect_with_max_id(collection=[], max_id=nil, &block)
    response = yield(max_id)
    collection += response
    response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
  end


  #accepts list of tweets and returns an array of words that are not found in the common word array
  def words_from_array(all_tweets)
    words = []
    all_tweets.each do |tweet|
      tweet.text.downcase.split(" ").each do |word|
        if check_noncommon_word(word)
          words.push(word)
        end
      end
    end
    words
  end

  #builds a hash with key = word, value = word count
  #returns sorted 2d array with top 100 elements based on count
  def count_frequency(word_list)
    counts = Hash.new(0)
    for word in word_list
      counts[word] += 1
    end
    counts.sort_by {|k,v| v}.reverse.to_a[0..99]
  end

  #check the passed in word against array of common words
  #O(1) due to known length of array
  def check_noncommon_word(word)
    common_words = ["a", "the", "of", "in", "to", "for", "at", "rt", "is", "and", "on", "&", "amp", "&amp;", "as", "has", "by", "be"]
    common_words.each do |common_word|
      if word == common_word
        return false
      end
    end
    return true
  end

end
