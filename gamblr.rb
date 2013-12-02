require 'sinatra'
require 'data_mapper'
require 'sinatra/reloader' if development?

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/bet.db")

SITE_TITLE = "Gamblr"
SITE_DESCRIPTION = "Money is icky!"

class Gambling
  include DataMapper::Resource
  property :id,           Serial
  property :stake,        Decimal, :required => true
  property :odds,         Decimal, :required => true
  property :lost_game,    Boolean, :required => true, :default => false
  property :started,      DateTime
  property :last_played,  DateTime
end

DataMapper.finalize.auto_upgrade!

get '/' do
  @games = Gambling.all :order => :id.desc
  @title = "Welcome"
  erb :home
end

post '/' do
  g = Gambling.new params[:id]
  g.stake = params[:stake]
  g.odds  = params[:odds]
  g.started     = Time.now
  g.last_played = Time.now
  redirect '/'
end