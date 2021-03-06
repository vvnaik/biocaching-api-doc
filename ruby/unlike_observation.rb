# Requires: 
#  $ sudo gem install rest-client
# 
#

# curl -v -XPOST -H 'Content-type:application/json' --data-binary '{"observation": {"taxon_id": 7552, "user_id":1, "observed_at":"2016-02-07 11:55:43 +0100", "latitude": 60.123, "longitude": 12.234}}' "http://localhost:3000/api/observations"


require 'rest-client'
require 'pp'


load './params.rb'


observation_params = {observation: {taxon_id: 61057, observed_at: Time.now.to_s, latitude: 65.123, longitude: 14.234, picture: File.new("greylag_goose.jpg", 'rb'), coordinate_uncertainty_in_meters: 30, individual_count: 5, sex: "3 males, 2 females", life_stage: "4 adults, 1 juvenile"}, :multipart => true, :content_type => 'application/json'}

begin
  
  params = {user:{email:@username, password:@password}}
  response = RestClient.post("http://#{@server}/users/sign_in.json", params, @http_headers)
  token = JSON.parse(response)["authentication_token"]
  
  puts JSON.parse(response)
  
  @http_headers.merge!({'X-User-Email' => @username, 'X-User-Token' => token})
  response = RestClient.get "http://#{@server}/observations?size=1", @http_headers

  puts response.code
  json = JSON.parse(response)
  o_id = json["hits"][0]["_id"]
   
  response = RestClient.post "http://#{@server}/observations/#{o_id}/unlike", nil, @http_headers
  
  puts response.code
  json = JSON.parse(response)
  puts JSON.pretty_generate(json)
  
  response = RestClient.get "http://#{@server}/observations/#{o_id}/likes",  @http_headers
  
  puts response.code
  json = JSON.parse(response)
  puts JSON.pretty_generate(json)
  
  
  
rescue RestClient::Unauthorized => e
  puts "unauthorized...."  
  exit
rescue  Exception => e

  puts e.message
  puts e.response if e.respond_to? response

  puts e.backtrace
  exit
end
