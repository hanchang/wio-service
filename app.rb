# encoding: utf-8
require 'sinatra'
require 'memcached'

class WIO < Sinatra::Application
end

$cache = Memcached.new("192.168.1.232:11211")

get '/' do
    "Welcome to the WIO API!"
end

get '/flush' do
    $cache.flush
end

get '/wio' do
    begin
        list = $cache.get 'wio'
    rescue ::Memcached::NotFound
        $cache.set 'wio', []
        list = []
    end

    list.to_s
end

get '/wio/:id' do
    :id
end

post '/wio/:id' do
    begin
        list = $cache.get 'wio'
    rescue ::Memcached::NotFound
        $cache.set 'wio', []
        list = []
    end

    unless list.include? params[:id]
        list << params[:id]
        $cache.set 'wio', list
        return "User #{params[:id]} added."
    end

    "User #{:id} already exists."
end

delete '/wio/:id' do
    begin
        list = $cache.get 'wio'
    rescue ::Memcached::NotFound
        $cache.set 'wio', []
        return "No user #{params[:id]} found, cannot delete."
    end

    if list.delete(params[:id]) == nil
        return "No user #{params[:id]} found, cannot delete."
    end

    $cache.set 'wio', list
    return "User #{params[:id]} deleted."
end
