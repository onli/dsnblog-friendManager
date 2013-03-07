#!/usr/bin/env ruby1.9.3
require 'rubygems'
require 'json'

require './database.rb'

require 'sinatra'
include ERB::Util
require 'sinatra/browserid'
set :sessions, true

set :port, 4200

get '/addFriend' do
    #einloggen, eigene url holen, an diese url neuen freund senden
    if authorized?
        ownUrl = Database.new.getUrl(authorized_email)
    end
    erb :addFriend, :locals => { :ownUrl => ownUrl, :name => params[:id], :url => params[:url] }
end

get '/addURL' do
    if ! authorized? && ! session.has_key?("origin")
        session[:origin] = request.referrer 
        erb :addURL, :locals => { :url => params[:url], :mail => params[:id] }
    else
        Database.new.addUser(authorized_email, params[:url])
        redirect session[:origin] if session.has_key?(:origin)
        redirect request.referrer if request.referrer != "/"
        erb :addURL, :locals => { :url => params[:url], :mail => params[:id] }
    end
    
end

get '/url' do
    content_type :json
    {:url => Database.new.getUrl(params[:id])}.to_json
end