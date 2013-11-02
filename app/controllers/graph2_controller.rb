# coding: utf-8
require "rubygems"
require "vkontakte_api"
require "oj"
require "hashie"

class Link < Hashie::Dash
  property :id
  property :id1
  property :id2
  property :value
end

class Name < Hashie::Dash
  property :id
  property :first
  property :last
  property :ph
end

VkontakteApi.configure do |config|
  config.app_id       = '3580989'      # ID приложения
  config.app_secret   = '1B3yGWgeTazayYdAL8wy' # защищенный ключ
  config.redirect_uri = 'http://api.vkontakte.ru/blank.html' #http://oauth.vk.com/blank.html
  config.faraday_options = {
ssl: {
:verify => false
},
}
end

access_token = '3dad3652d71811da69f177711598e26e401f918c20580e1d74ebdff0e28997371668a7cd2750205f4a03c'
@vk = VkontakteApi::Client.new(access_token)


class Graph2Controller < ApplicationController
  def index
    @names = []
    @links = []
    n = Oj.load(File.open('public/names.json', 'r'))
    m = Oj.load(File.open('public/links.json', 'r'))
    n.each do |i|
      @names.push(Name.new(i))
    end 
    m.each do |c|
      @links.push(Link.new(c))
    end 
  end
end


