require 'trisulrp'
require 'json'
require 'lita'
require 'open-uri'
require 'base64'
module Lita
  module Handlers
    class Hello < Handler
     extend Lita::Handler::HTTPRouter
      http.get "/kiwii.png" do |request, response2|
         file=File.read("/home/lita/walle/kiwi.svg")
	 #response2["Content-Type"] = "image/png"
	 response2.write(file)
	 response2.finish
	 p "tttttttttttttteeeeeeeeeeeeeee"
      end

      route(/^hey\s(.*)/, :index, command: false, help: { "index" => "To test trp" })
      route(/^image/, :imagery, command: false, help: { "imagery" => "test to send image thru http" })
      route(/^heya/, :hyper, command: false, help: { "hyper" => "To test http" })
 


      def index(response)
        conn = "tcp://demo.trisul.org:12006"
        tint = TRP::TimeInterval.new()
        tint.to=  TRP::Timestamp.new({:tv_sec=>Time.now.tv_sec})
        tint.from= TRP::Timestamp.new()
        tint.from.tv_sec = tint.to.tv_sec - 3600
        req = TrisulRP::Protocol.mk_request(TRP::Message::Command::COUNTER_GROUP_TOPPER_REQUEST,{:counter_group=>response.matches[0][0],:meter=>0,:maxitems=>2,time_interval:tint})
        TrisulRP::Protocol.get_response_zmq(conn,req) do |resp|
          resp.keys.each do |key|
            response.reply("#{key.label}=#{key.metric*300}")
          end
        end  
      end#def




      def imagery(response)
          #http.get "/lena.jpg" do |request, response2|
          #file=File.read("/home/lita/walle/lena.jpg")
	  #response2["Content-Type"] = "image/jpg"
	  #response2.write(file)
	  #response2.finish
	  #p "tttttttttttttteeeeeeeeeeeeeee"
	#end
        response.reply("http://139.59.66.54:9000/kiwii.png")
      end
     
     
     
      def hyper(response)
	response.reply("https://content.linkedin.com/content/dam/me/learning/blog/2016/september/garrick-powerpoint-/SVG-1.png")
      end
    
    
    
    end#CLASS
    Lita.register_handler(Hello)
  end#module handlers
end#modulelita
