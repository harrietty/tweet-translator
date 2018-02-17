ENV['RACK_ENV'] = 'test'
print ENV
require_relative '../index'
require 'rspec'
require 'rack/test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

describe 'The HelloWorld App' do
  # include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'serves the index page on the home route' do
    get '/'
    expect(last_response.status).to eq 200
    expect(last_response.body).to include '<h1>Tweet Translater</h1>'
  end

  it 'serves the not found page' do
    post '/tweets', params = {'username' => 'harrjkljkliiiiiiiinb'}
    expect(last_response.status).to eq 200
    expect(last_response.body).to include 'harrjkljkliiiiiiiinb not found'
  end
  
  it 'serves the protected user page' do
    post '/tweets', params = {'username' => 'harrietty'}
    expect(last_response.status).to eq 200
    expect(last_response.body).to include 'harrietty has protected their tweets'
  end

  it 'serves the translation page' do
    post '/tweets', params = {'username' => 'harri_etty'}
    expect(last_response.status).to eq 200
    expect(last_response.body).to include 'Translations of your most common words'
  end
end
