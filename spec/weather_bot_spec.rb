
RSpec.describe "WeatherBot" do 
  
  let!(:twitter_client_mock){double("Twitter client")}
  let!(:weather_bot){WeatherBot.new}
  
  before do 
    allow(weather_bot).to receive(:twitter_client).and_return(twitter_client_mock)
  end 
  
  it "エラーなく予報をツイートすること" do 
    
# Twitter clientのモックを作る。(引数は任意の文字列。なくても良い。)
    # twitter_client_mock = double("Twitter client")
    # twitter_client_mock = double
    
# updateメソッドが呼び出せるようにする。(モックオブジェクトが呼び出せるメソッドをreceiveに渡す。)
    # allow(twitter_client_mock).to receive(:update)
    
# 上のallow(twitter_client_mock).to receive(:update)の機能に加え、セットアップしたメソッド(:update)が、呼び出されたかどうかを検証する。
# そのメソッドが呼び出されないとテスト失敗になる。
    expect(twitter_client_mock).to receive(:update)
    
    
# ※ allowとexpectの使い分け
# allow → 単に実装を置き換えたいだけの場合に使用。
# expect → 実装を置き換える + 引数のメソッドが呼び出されたが検証したい場合に使用。
    
    # weather_bot = WeatherBot.new
    
# twitter_clientメソッドが呼ばれたら上で作ったモックを返すように実装を書き換える。
# twitter_clientメソッドが呼び出されたら、Twitter::REST::Client.newではなく、twitter_client_mockを返すように変更。
    # allow(weather_bot).to receive(:twitter_client).and_return(twitter_client_mock)
    
    expect{weather_bot.tweet_forecast}.not_to raise_error
    
  end 
  
  it "エラーが起きたら通知すること" do 
    # twitter_client_mock = double("Twitter client")
    
# updateメソッドが呼び出されたらエラーを発生させる。
    allow(twitter_client_mock).to receive(:update).and_raise(StandardError)
    
    # weather_bot = WeatherBot.new
    # allow(weather_bot).to receive(:twitter_client).and_return(twitter_client_mock)
    
# notifyメソッドが呼ばれることを検証する。
    expect(weather_bot).to receive(:notify)
    
# tweet_forecastメソッドを呼び出す。
# weather_botのnotifyメソッドが呼び出されたらテストはパスする。
    weather_bot.tweet_forecast
    
    
  end 
  
  
end 