require 'sinatra'
require 'data_mapper'
require 'sinatra/reloader' if development?

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/bet.db")

SITE_TITLE = "Gamblr"
SITE_DESCRIPTION = "Money is icky!"

class Gambling
  include DataMapper::Resource
  property :id,         Serial
  property :stake,      Decimal
  property :odds,       Decimal
  property :payout,     Decimal
  property :started,    DateTime
  property :last_play,  DateTime
end

DataMapper.finalize.auto_upgrade!

get '/' do
  @game = Gambling.all :order => :id.desc
  @title = "Welcome"
  erb :home
end