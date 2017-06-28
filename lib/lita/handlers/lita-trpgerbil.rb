require 'json'
require 'lita'
require 'open-uri'
require 'base64'
require 'gerbilcharts'

module Lita
  module Handlers
    class Trisul < Handler
        $id=rand(100)
        extend Lita::Handler::HTTPRouter
        http.get "/ers:id.png", :example
        def example(request,response2)
         `rsvg-convert /tmp/chart.svg -o /tmp/chart.png`
         file=File.read("/tmp/chart.png")
         response2["Content-Type"] = "image/png"
         response2.write(file)
         response2.finish
        end


        def chart_generate(data)
         test_vector_tm1 = data
=begin         tbeg = Time.local( 1978, "jun", 5, 9, 10, 0, 0)
         sbeg = tbeg
         sec_inc = 50
         for i in (0..20)
           test_vector_tm1 << [sbeg + i*sec_inc, i*sec_inc*250*rand() ]
=end         end
         mod1 = GerbilCharts::Models::TimeSeriesGraphModel.new("External Gateway")
         mod1.add_tuples test_vector_tm1
         modgroup = GerbilCharts::Models::GraphModelGroup.new("Hosts")
         modgroup.add(mod1)
         mychart = GerbilCharts::Charts::AreaChart.new( :width => 750, :height => 250, :squarize => true,:javascripts => ['inline:gerbil.js' ],
                                :auto_tooltips => false, :style => 'inline:brushmetal.css' )
         mychart.setmodelgroup(modgroup)
         mychart.render('/tmp/chart.svg')
        end


        route(/^Total\straffic\s(.*)/i, :trpchart, command: false, help: { "trchart" => "To chart trp" })  


        def trpchart(response)
         if response.matches[0]=="hey" and ! response.matches[0].is_a?Array
          response.reply("Please enter hey <counter_group_id>")
         end
         conn = "tcp://demo.trisul.org:12006"
         tint = TRP::TimeInterval.new()
         tint.to=  TRP::Timestamp.new({:tv_sec=>Time.now.tv_sec})
         tint.from= TRP::Timestamp.new()
         tint.from.tv_sec = tint.to.tv_sec - 3600
         keyt = TRP::KeyT.new({:key=>"TOTALBW"})
         req = TrisulRP::Protocol.mk_request(TRP::Message::Command::COUNTER_ITEM_REQUEST,{:counter_group=>response.matches[0][0].strip,:key=>keyt,time_interval:tint})
         data = []
         TrisulRP::Protocol.get_response_zmq(conn,req) do |resp|
          resp.stats.each do |stat|
            data << [ stat.ts_tv_sec,stat.values[0]*8]
          end#stats
         end#trp
         chart_generate(data)
         response.reply("http://34.212.97.93:3000/ers#{$id}.png")
         $id=rand(100)
        end#def

      Lita.register_handler(self)
    end #CLASS
  end #module handlers
end #modulelita
                    
