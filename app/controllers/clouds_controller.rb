class CloudsController < ApplicationController
  include ApplicationHelper

  def home
  end

  def search
    #get list of tweets from username passed into search
    all_tweets = $twitter_client.get_all_tweets(params[:search])

    #find a list of words based on the tweets
    words = words_from_array(all_tweets)

    #set instance variable for 2d array of words
    @counts = count_frequency(words)
  end
end
