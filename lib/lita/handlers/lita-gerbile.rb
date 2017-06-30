require 'json'
require 'lita'
require 'open-uri'
require 'base64'
require 'gerbilcharts'
module Lita
  module Handlers
    class Gerbile < Handler
        config :trp_server_endpoint
	config :local_http_server   
	$id=rand(100)
        extend Lita::Handler::HTTPRouter
        http.get "/chart:id.png", :example
        def example(request,response)
         chart_generate()
         `rsvg-convert /tmp/sq_linechart.svg -o /tmp/test.png`
         file=File.read("/tmp/test.png")
         response2["Content-Type"] = "image/png"
         response2.write(file)
         response2.finish
        end


        def chart_generate()
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
         mychart.render('/tmp/sq_linechart.svg')
        end


        route(/^chart me/, :charts, command: false, help: { "charts" => "To test http" })


        def charts(response)
		response.reply("#{config.local_http_server}/chart#{$id}.png")
         $id=rand(100)
        end

    end#CLASS
    # Lita.register_handler(Gerbile)
  end#module handlers
end#modulelita
                    
