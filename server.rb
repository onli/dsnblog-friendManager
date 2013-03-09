#!/usr/bin/env ruby1.9.3
require 'rubygems'
require 'json'

require './database.rb'

require 'sinatra'
include ERB::Util
require 'sinatra/browserid'
set :sessions, true

set :port, 4200

get '/' do
    "dsnblog-friendmanager is running"
end

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

post '/subscriptions' do
    # this should be called from the browser when adding a friend
    Database.new.subscribe(params[:id], authorized_email) if authorized?
end

get '/notify' do
    #TODO: Add rate-limit to prevent misuse
    db = Database.new
    db.getSubscribers(params[:id]).each do |id|
        url = db.getUrl(id)
        uri = URI.parse(url + '/entry')
        http = Net::HTTP.new(uri.host, uri.port)
        http_request = Net::HTTP::Post.new(uri.request_uri)
        http_request.set_form_data({:id => params[:id]})
        begin
            http.request(http_request)
        rescue => error
            puts "Error notifying #{url}: #{error}"
        end
    end
end