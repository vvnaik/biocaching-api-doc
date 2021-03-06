# Requires: 
#  $ sudo gem install rest-client
# 
#

# curl -v -XPOST -H 'Content-type:application/json' --data-binary '{"observation": {"taxon_id": 7552, "user_id":1, "observed_at":"2016-02-07 11:55:43 +0100", "latitude": 60.123, "longitude": 12.234}}' "http://localhost:3000/api/observations"


require 'rest-client'
require 'pp'


load './params.rb'


# Denne må endres dersom det er bildet som skal endres: 
# - picture_attributes: {primary: true, picture: File.new("greylag_goose.jpg", 'rb')}
# - legge til id for bildet som skal endres

observation_params = {observation: {taxon_id: 1373, observed_at: Time.now.to_s, latitude: 61.9, longitude: 12.1, picture: File.new("flaggermus.jpg", 'rb')}, :multipart => true, :content_type => 'application/json'}

begin
  
  params = {user:{email:@username, password:@password}}
  response = RestClient.post("http://#{@server}/users/sign_in.json", params)
  token = JSON.parse(response)["authentication_token"]
  
  puts JSON.parse(response)
  
  @http_headers.merge!({'X-User-Email' => @username, 'X-User-Token' => token})
  
  response = RestClient.put "#{@server}/observations/5", observation_params, @http_headers
  
  puts response.code
  json = JSON.parse(response)
  puts JSON.pretty_generate(json)
rescue RestClient::Unauthorized => e
  puts "unauthorized...."  
  exit
rescue  Exception => e
  puts e.message
  puts e.class.name
  exit
end
