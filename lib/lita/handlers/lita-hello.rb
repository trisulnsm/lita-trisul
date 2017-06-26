require 'json'
require 'lita'
require 'open-uri'
require 'base64'
module Lita
  module Handlers
    class Hello < Handler
	$id=rand(100)
        extend Lita::Handler::HTTPRouter
        http.get "/kkr:id.png", :example
        def example(request,response2) 
	 `ruby /home/lita/test_lines.rb`
	 `rsvg-convert /tmp/sq_linechart.svg -o /home/lita/robot/test.png`
	 file=File.read("/home/lita/robot/test.png")
	 response2["Content-Type"] = "image/png"
	 response2.write(file)
	 response2.finish
         p "/kkr#{$id}.png"
        end

      route(/^hey\s(.*)/, :index, command: false, help: { "index" => "To test trp" })
      route(/^hey$/, :index, command: false, help: { "index" => "To test trp" })
      route(/^image/, :imagery, command: false, help: { "imagery" => "test to send image thru http" })
      route(/^pug me plis/, :hyper, command: false, help: { "hyper" => "To test http" })
 


      def index(response)

        if response.matches[0]=="hey" and ! response.matches[0].is_a?Array

         response.reply("Please enter hey <counter_group_id>")
        end
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
       response.reply("http://139.59.66.54:9000/kkr#{$id}.png")
       $id=rand(100)

      end
     
     
     
      def hyper(response)
	 response.reply("ihello")
      end
    
    
    
    end#CLASS
    Lita.register_handler(Hello)
  end#module handlers
end#modulelita
