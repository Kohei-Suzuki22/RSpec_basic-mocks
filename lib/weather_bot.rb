require 'twitter'

class WeatherBot
  
  def search_first_weather_tweet 
    twitter_client.search("天気").first.text
  end 
  
  def tweet_forecast
    twitter_client.update '今日は晴れです'
    rescue =>e
      notify(e.class)
    # end
  end

  def twitter_client
    Twitter::REST::Client.new
  end
  
  #エラーの通知を行うメソッド
  def notify(error)
    puts "エラーが発生したことをここに通知します。"
    puts "エラーの種類: #{error}"
  end 
  
end