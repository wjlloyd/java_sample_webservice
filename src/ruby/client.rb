require 'net/http'
require 'json'
def do_websrvclient
 uri = URI('http://localhost:8080/csip/m/temp/1.0')
 http = Net::HTTP.new(uri. host)
 req = Net::HTTP::Post.new(uri.path, initheader =
 {'content-type' =>'application/json',
 'accept' =>'application/json'})
 req.body = {
 metainfo: {},
 parameter: [
 { name: "temp",
 value: 25 }
 ]
 }.to_json
 res = http.request(req)
 puts "response #{res.body}"
rescue => e
 puts "failed #{e}"
end
do_websrvclient
