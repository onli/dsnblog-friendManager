#!/usr/bin/env ruby1.8
require 'rubygems'

require './database.rb'

require 'sinatra'
include ERB::Util
require 'sinatra/browserid'
set :sessions, true

get '/addFriend' do
    #einloggen, eigene url holen, an diese url neuen freund senden
    
    db = Database.new
    ownUrl = nil
    if authorized?
        ownUrl = db.getUrl(authorized_email)
    end
    puts params[:name] 
    puts params[:url]
    puts ownUrl
    erb :addFriend, :locals => { :ownUrl => ownUrl, :name => params[:name], :url => params[:url] }
end