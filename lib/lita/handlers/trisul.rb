require 'json'
require 'lita'
require 'open-uri'
require 'base64'
require 'gerbilcharts'
require 'trisulrp'

module Lita
  module Handlers
    class Trisul < Handler

        $id=rand(100)
        extend Lita::Handler::HTTPRouter

        config  :trp_server_endpoint
        config  :local_http_server

        http.get "/trpquery:id.png", :example
        
	def example(request,response2)
         `rsvg-convert /tmp/chart.svg -o /tmp/chart.png`
         file=File.read("/tmp/chart.png")
         response2["Content-Type"] = "image/png"
         response2.write(file)
         response2.finish
        end


        route(/^Total\straffic\s(.*)/i, :trpchart, command: false, help: { "trpchart" => "To chart trp" })  
        route(/^nextnumber/i, :nextnumber, command: false, help: { "nextnumber" => "Incrementer" })  


	def nextnumber(response)
		nn = redis.get("nextnum")  || 0 
		response.reply("hello #{nn}")
		redis.set("nextnum","#{nn.to_i+1}")
	end



        def chart_generate(data)
         mod1 = GerbilCharts::Models::TimeSeriesGraphModel.new("External Gateway")
         mod1.add_tuples data
         modgroup = GerbilCharts::Models::GraphModelGroup.new("Hosts")
         modgroup.add(mod1)
         mychart = GerbilCharts::Charts::AreaChart.new( :width => 750, :height => 250, :squarize => true,
                                :auto_tooltips => false,:style => 'inline:brushmetal.css' )
         mychart.setmodelgroup(modgroup)
         mychart.render('/tmp/chart.svg')
        end



        def trpchart(response)
         if response.matches[0]=="hey" and ! response.matches[0].is_a?Array
          response.reply("Please enter hey <counter_group_id>")
         end
         tint = TRP::TimeInterval.new()
         tint.to=  TRP::Timestamp.new({:tv_sec=>Time.now.tv_sec})
         tint.from= TRP::Timestamp.new()
         tint.from.tv_sec = tint.to.tv_sec - 3600
         keyt = TRP::KeyT.new({:key=>"TOTALBW"})
         req = TrisulRP::Protocol.mk_request(TRP::Message::Command::COUNTER_ITEM_REQUEST,{:counter_group=>response.matches[0][0].strip,:key=>keyt,time_interval:tint})
         data = []
         TrisulRP::Protocol.get_response_zmq(config.trp_server_endpoint,req) do |resp|
          resp.stats.each do |stat|
            data << [ stat.ts_tv_sec,stat.values[0]*8]
          end#stats
         end#trp
         chart_generate(data)
         response.reply("#{config.local_http_server}/trpquery#{$id}.png")
         $id=rand(100)
        end#def


    end #CLASS

    Lita.register_handler(Trisul)
  end #module handlers
end #modulelita
                    
