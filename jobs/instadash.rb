require 'sinatra'
require 'instagram'

Instagram.configure do |config|
  # For client id and client secret you need to register an application at http://instagram.com/developer
  config.client_id = ENV['INSTAGRAM_CLIENT_ID'] || '908dd6d7ef9b4bbdb40199bb07689bc4'
  config.client_secret = ENV['INSTAGRAM_CLIENT_SECRET'] || '43d646ea91834fb7876ae20b6787a1ce'
  # To obtain your access token I followed this: http://jelled.com/instagram/access-token
  config.access_token = ENV['INSTAGRAM_ACCESS_TOKEN'] || '5406666048.908dd6d.e267d17a6cbc488ba55eaf4ad2917328'
end

# This needs the user ID you want to display images of. Find out the ID for a username here: http://jelled.com/instagram/lookup-user-id
user_id = ENV['INSTAGRAM_USER_ID'] || '548145718'

# Uncomment the following line if you want to see the received output in your terminal (for debugging)
# puts Instagram.user_recent_media("#{user_id}")

SCHEDULER.every '2m', :first_in => 0 do |job|
  photos = Instagram.user_recent_media("#{user_id}")
  if photos
    photos.map! do |photo|
      { photo: "#{photo.images.low_resolution.url}" }
    end
  end
  send_event('instadash', photos: photos)
end
