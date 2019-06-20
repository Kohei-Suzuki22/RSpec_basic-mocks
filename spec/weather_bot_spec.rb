
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
    # expect(twitter_client_mock).to receive(:update).once
    
# 引数の内容を検証
# with(検証したい引数の内容)で、引数の中身を検証できる。
    # expect(twitter_client_mock).to receive(:update).with("今日は晴れです")
    
# .withと呼び出し回数の検証の組み合わせ
    expect(twitter_client_mock).to receive(:update).with("今日は晴れです").once
    # expect(twitter_client_mock).to receive(:update).with(/晴れ/).once
    
#　引数が２つ以上ある場合
    # expect(twitter_client_mock).to receive(:update).with("今日は晴れです","more_argument")

# どんな引数でも良い場合
    # expect(twitter_client_mock).to receive(:update).with("今日は晴れです", anything)

# ハッシュを引数として渡す場合
# そのままハッシュ(key: value)をWithに渡す。
    # expect(user).to receive(:save_profile).with(name: "Bob", email: "Bob@example.com")
    
# 特定のkeyとvalueだけ検証する
# hash_includingを使う。
    # expect(user).to receive(:save_profile).with(hash_including(name: "Bob"))
    
    
    
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
    
# notifyメソッドが呼ばれることを検証する。(.onceで呼び出し回数を検証。)
    expect(weather_bot).to receive(:notify).once
    
    
=begin
  
  呼び出し回数検証メソッド
  ・once              : 一回だけよばれる。
  ・twice             : ちょうど二回。
  ・exactly(n).times  : n回呼ばれる。
  ・at_least(:once)   : 一回以上
  ・at_least(:twice)  : 二回以上
  ・at_least(n).times : n回以上
  ・at_most(:once)    : 一回以下(0または1回)
  ・at_most(:twice)   : ２回以下
  ・at_most(n).times  : n回以下
  
  
  

=end 
    
    
# tweet_forecastメソッドを呼び出す。
# weather_botのnotifyメソッドが呼び出されたらテストはパスする。
    weather_bot.tweet_forecast
    
    
  end
  
# 対象クラスの全インスタンスに対して目的のメソッドをモック化できる。
# →あまり使わないほうがよい。
#  ・コードが理解しづらい
#  ・この機能が必要になるということはアプリケーションの設計がいけてない
#  ・不具合が多い
  it "エラーなく予報をツイートすること(allow_any_instance_ofを使用)" do 
    twitter_client_mock = double("Twitter client")
    allow(twitter_client_mock).to receive(:update)
    
    #WeatherBotクラスの全インスタンスに対して、twitter_clientメソッドが呼ばれたときにモックを返すようにする
    allow_any_instance_of(WeatherBot).to receive(:twitter_client).and_return(twitter_client_mock)
    
    weather_bot = WeatherBot.new 
    expect{weather_bot.tweet_forecast}.not_to raise_error
  end 
  
  
#モックを何個も作って連結する場合: receive_message_chain
  
  it "「天気」を含むツイートを返すこと" do 
#     status_mock = double("Status")
#     allow(status_mock).to receive(:text).and_return("西脇市の天気は曇りです")
    
#     twitter_client_mock = double("Twitter client")
# # モックがモックを返すようなセットアップとなる
#     allow(twitter_client_mock).to receive(:search).and_return([status_mock])
    
#     weather_bot = WeatherBot.new
#     allow(weather_bot).to receive(:twitter_client).and_return(twitter_client_mock)
    
#     expect(weather_bot.search_first_weather_tweet).to eq "西脇市の天気は曇りです"

    
    weather_bot = WeatherBot.new 
# receive_message_chain("")により、 「twitter_client => search => first => text」と
# ４つのメソッドを呼び出した結果を一気にモック化できる。
    allow(weather_bot).to receive_message_chain("twitter_client.search.first.text").and_return("西脇市の天気は曇りです")
    
    expect(weather_bot.search_first_weather_tweet).to eq "西脇市の天気は曇りです"
  end
  
  
  it "エラーなく予報をツイートすること(as_null_object)" do 
# null object としてモックを作成すること
      twitter_client_mock = double("Twitter client").as_null_object
# これにより、どんなメソッドがモックに対して呼ばれても許容されるので、
# allow(twitter_client_mock).to receive(:update)は不要。

# どんなメソッドでもきょようされるため、下のコードはエラーにならない。
      twitter_client_mock.foobar.hoge.piyo


      weather_bot = WeatherBot.new 
      allow(weather_bot).to receive(:twitter_client).and_return(twitter_client_mock)
      expect{weather_bot.tweet_forecast}.not_to raise_error
  end 
  
end 