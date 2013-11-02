require "rubygems"
require "vkontakte_api"

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

class Epi < Hashie::Dash
  property :owner_id, :required => true
  property :message_id, :required => true 
  property :date 
  property :text 
  property :reposts_count
  property :likes_count
end

class MainController < ApplicationController
  def index
    id = 695433
    access_token = '3dad3652d71811da69f177711598e26e401f918c20580e1d74ebdff0e28997371668a7cd2750205f4a03c'
    @vk = VkontakteApi::Client.new(access_token)
    g = ['-15755094']
    @array = []
    g.each do |id|
      c = 0
      wall_count = @vk.wall.get(owner_id: id, count: 1, offset: 0)[0]
      wall_count = (wall_count / 100) + 1
      if wall_count > 1
        wall_count = 1
      end
      
      while c < wall_count
        wall_list = @vk.wall.get(owner_id: id, count: 100, offset: c*100)
        wall_list.delete(wall_list[0])

        wall_list.each do |wall_msg|
          msg_date = Time.at(wall_msg.date)

          if msg_date.year > 2012
            if wall_msg.copy_owner_id == nil
              if wall_msg.reposts[:count] > 10
                @array.push Epi.new(:owner_id => wall_msg.from_id, :message_id => wall_msg.id, :date => wall_msg.date, :text => wall_msg.text, :reposts_count => wall_msg.reposts[:count], :likes_count => wall_msg.likes[:count])
              end
            else
              epmsg = @vk.wall.getById(posts: wall_msg.copy_owner_id.to_s + '_' + wall_msg.copy_post_id.to_s)
              begin
                if epmsg[0].reposts[:count] > 10 and epmsg[0].reposts[:count] < 1500
                  @array.push Epi.new(:owner_id => wall_msg.copy_owner_id, :message_id => wall_msg.copy_post_id, :date => epmsg[0].date, :text => epmsg[0].text, :reposts_count => epmsg[0].reposts[:count], :likes_count => epmsg[0].likes[:count])
                end
              rescue
              end
            end
          end
        end
        c = c + 1
      end
    end
  end
end
  

