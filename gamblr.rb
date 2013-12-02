require 'sinatra'
require 'data_mapper'
require 'sinatra/reloader' if development?

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/gamblr.db")

SITE_TITLE = "Gamblr"
SITE_DESCRIPTION = "Money is icky!"

class Gambling
  include DataMapper::Resource
  property :id,           Serial
  property :stake,        Float, :required => true
  property :odds,         Float, :required => true
  property :wager,        Float, :required => true, :default => 0
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
  g.save
  redirect '/'
end

get '/:id' do
  @game = Gambling.get params[:id]
  @title = "Playtime"
  erb :play
end

put '/:id' do
  g = Gambling.get params[:id]
  g.wager = params[:wager]
  g.wager = g.stake / g.odds if g.wager * g.odds > g.stake
  pot = g.wager * g.odds
  roll = rand(g.odds)
  roll == 0 ? g.stake += pot : g.stake -= pot
  g.lost_game = true if g.stake <= 0
  g.last_played = Time.now
  g.save
  redirect '/'
end