require 'json'
require 'lita'
require 'open-uri'
require 'base64'
require 'gerbilcharts'
module Lita
  module Handlers
    class Trisul < Handler

        $id=rand(100)					###Global variable to randomly allocate http routes
        extend Lita::Handler::HTTPRouter

        config  :trp_server_endpoint			###Trisul Remote protocol endpoint along with port number to query for data
        config  :local_http_server			###Local HTTP Server address with port number to display query responses

        http.get "/trpchart:id.png", :example		###Creation of HTTP Routes to respond with charts

        def example(request,response2)
         `rsvg-convert /tmp/chart.svg -o /tmp/chart.png`### Conversion of charts from .svg format provided by GerbilCharts to .png format
         file=File.read("/tmp/chart.png")
         response2["Content-Type"] = "image/png"
         response2.write(file)
         response2.finish
        end

		###########		CREATION OF CHAT ROUTES TO RESPOND TO THE USER QUERIES AT THE FRONT END		###########



        route(/^Total\straffic(\s(.*))?(\sfor\s(.*))?/i, :trpchart, command: false, help: { "trpchart" => "To chart trp" })  
	route(/^Set Counter group\s(.*)\sfor\s(.*)/i, :setcg, command: false, help: { "setcg" => "To set cg in redis" })
	route(/^Remove Counter Group/i, :removecg, command: false, help: { "removecg" => "To remove the set cg in redis"})

		###########		FUNCTION DEFINITIONS TO FETCH FROM THE BACKEND AND DISPLAY THE RESPONSE		###########


	def setcg(response)
          Lita.redis.set('/litatrisul/countergroup',response.matches[0][0])
          response.reply("Value set")
        end

	def removecg(response)
	  Lita.redis.del('/litatrisul/countergroup')
	  Lita.redis.set('/litatrisul/countergroup',"{393B5EBC-AB41-4387-8F31-8077DB917336}")
	  response.reply("Stored Counter Group has been removed.")
	  response.reply("Setting to default Group \"Aggregates\" with ID {393B5EBC-AB41-4387-8F31-8077DB917336} ")
	end


        def trpchart(response)
         if response.matches[0]=="hey" and ! response.matches[0].is_a?Array
          response.reply("Please enter hey <counter_group_id>")				###Check query syntax of the user
         end

         tint = TRP::TimeInterval.new()							###Create the time interval to query from
	 if(!response.matches[0][0]==nil)
           if(response.matches[0][1]["last hour"]||response.matches[0][0]["last hour"])
		 tint.to =  TRP::Timestamp.new({:tv_sec=>Time.now.tv_sec})
       		 tint.from = TRP::Timestamp.new()
        	 tint.from.tv_sec = tint.to.tv_sec - 3600
  	   elsif(response.matches[0][1]["yesterday"]||response.matches[0][0]["yesterday"])
		tint.to = TRP::Timestamp.new({:tv_sec=>Time.parse(Date.today.to_s).tv_sec})
		tint.from = TRP::Timestamp.new({:tv_sec=>Time.parse(Date.today.to_s).tv_sec-86400})
	   else
		tint.to = TRP::Timestamp.new({:tv_sec=>Time.now.tv_sec})
		tint.from = TRP::Timestamp.new({:tv_sec=>Time.parse(Date.today.to_s).tv_sec})
	   end
	 else
	  	tint.to = TRP::Timestamp.new({:tv_sec=>Time.now.tv_sec})
	 	tint.from = TRP::Timestamp.new({:tv_sec=>Time.parse(Date.today.to_s).tv_sec})
	 end


         keyt = TRP::KeyT.new({:key=>"TOTALBW"})					###Set the counter group ID

         guid =""
         if(!response.matches[0][0]==nil)
	   if(response.matches[0][0].start_with?("{"))					###Check if the GID is given or has to be fetched
	          guid = response.matches[0][0]
	   end
         else
	          guid = Lita.redis.get('/litatrisul/countergroup') 
         end 
	 req = TrisulRP::Protocol.mk_request(TRP::Message::Command::COUNTER_ITEM_REQUEST,{:counter_group=>guid,:key=>keyt,time_interval:tint})
	 

         data = []									###Create an array to pass data to charting func.
	 total_bytes=0									###Create variable to count stats
         TrisulRP::Protocol.get_response_zmq(config.trp_server_endpoint,req) do |resp|
          resp.stats.each do |stat|
            data << [ stat.ts_tv_sec,stat.values[0]*8]
	    total_bytes += stat.values[0]
          end#stats
         end#trp
         chart_generate(data)								###Call the chart generation function and pass the data
         response.reply("#{config.local_http_server}/trpchart#{$id}.png")		###Respond with the http route created for the response image
	 response.reply("TOTAL BANDWIDTH : #{total_bytes} bytes")
         $id=rand(100)									###Randomise global variable for the next query, if any
        end#def


        def chart_generate(data)							###GerbilCharts Charting function
         mod1 = GerbilCharts::Models::TimeSeriesGraphModel.new("External Gateway")
         mod1.add_tuples data
         modgroup = GerbilCharts::Models::GraphModelGroup.new("Hosts")
         modgroup.add(mod1)
         mychart = GerbilCharts::Charts::AreaChart.new( :width => 750, :height => 250, :squarize => true,
                                :auto_tooltips => false,:style => 'inline:brushmetal.css' )
         mychart.setmodelgroup(modgroup)
         mychart.render('/tmp/chart.svg')
        end


      Lita.register_handler(self)
    end #CLASS
  end #module handlers
end #modulelita
                    
