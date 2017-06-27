require 'json'
require 'lita'
require 'open-uri'
require 'base64'
require 'gerbilcharts'
module Lita
  module Handlers
    class Gerbile < Handler
        config :config.trisul.host, type: String, required: true
        config :config.public.host, type: String, required: true
        $id=rand(100)
        extend Lita::Handler::HTTPRouter
        http.get "/kkr:id.png", :example
        def example(request,response)
         chart_generate()
         `rsvg-convert /tmp/chart.svg -o /tmp/chart.png`
         file=File.read("/tmp/chart.png")
         response2["Content-Type"] = "image/png"
         response2.write(file)
         response2.finish
        end


        def chart_generate(test_vector_tm1)
         test_vector_tm1 = []
         tbeg = Time.local( 1978, "jun", 5, 9, 10, 0, 0)
         sbeg = tbeg
         sec_inc = 50
         for i in (0..20)
           test_vector_tm1 << [sbeg + i*sec_inc, i*sec_inc*250*rand() ]
         end
         mod1 = GerbilCharts::Models::TimeSeriesGraphModel.new("External Gateway")
         mod1.add_tuples test_vector_tm1
         modgroup = GerbilCharts::Models::GraphModelGroup.new("Hosts")
         modgroup.add(mod1)
         mychart = GerbilCharts::Charts::LineChart.new( :width => 750, :height => 250, :squarize => true,:javascripts => ['inline:gerbil.js' ],
                                :auto_tooltips => false, :style => 'inline:brushmetal.css' )
         mychart.setmodelgroup(modgroup)
         mychart.render('/tmp/chart.svg')
        end


        route(/^chart me/, :trpchart, command: false, help: { "trchart" => "To chart trp" })  


        def trpchart(response)
         if response.matches[0]=="hey" and ! response.matches[0].is_a?Array
          response.reply("Please enter hey <counter_group_id>")
         end
         conn = "tcp://$config.trisul.host"
         tint = TRP::TimeInterval.new()
         tint.to=  TRP::Timestamp.new({:tv_sec=>Time.now.tv_sec})
         tint.from= TRP::Timestamp.new()
         tint.from.tv_sec = tint.to.tv_sec - 3600
         req = TrisulRP::Protocol.mk_request(TRP::Message::Command::COUNTER_GROUP_TOPPER_REQUEST,{:counter_group=>response.matches[0][0],:meter=>0,:maxitems=>2,time_interval:tint})
         data = []
         TrisulRP::Protocol.get_response_zmq(conn,req) do |resp|
          resp.keys.each do |key|
            #response.reply("#{key.label}=#{key.metric*300}")
            data << [#{key.label},#{key.metric}]
          end
         end
         chart_generate(data) 
         response.reply("http://$config.public.host/kkr#{$id}.png")
         $id=rand(100)
        end#def

    end#CLASS
    Lita.register_handler(Gerbile)
  end#module handlers
end#modulelita
                    
