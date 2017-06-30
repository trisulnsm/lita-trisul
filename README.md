# lita-trisul

[![Build Status](https://travis-ci.org/kkn1806/lita-trisul.png?branch=master)](https://travis-ci.org/kkn1806/lita-trisul)
[![Coverage Status](https://coveralls.io/repos/kkn1806/lita-trisul/badge.png)](https://coveralls.io/r/kkn1806/lita-trisul)



Lita-Trisul is a chat bot for Trisul Network Analytics

## Installation

Add lita-trisul to your Lita instance's Gemfile:

``` ruby
gem "lita-trisul"
```

## Configuration

Add the following config parameters

````

# where the Trisul TRP server is
config.handlers.trisul.trp_server_endpoint="tcp://192.168.2.8:12006"

# external IP of this host for serving images
config.handlers.trisul.local_http_server="http://192.168.2.11:3000"

````

TODO: Describe any configuration attributes the plugin exposes.

## Usage

TODO: Describe the plugin's features and how to use them.




## Additional instructions 


### Base install 

1. Fork and then
    - Ubuntu -  `git clone https://github.com/trisulnsm/lita-trisul.git`
2. Install ruby  
    - Ubuntu -  `sudo apt-get install ruby ruby-dev`
3. Install Ruby binding for ZMQ - we use this to connect to Trisul domain 
    - Ubuntu - `sudo apt-get install ruby-ffi-rzmq`
4. Install other dependencies  
    - Ubuntu - `sudo apt-get install build-essential libssl-dev redis-server librsvg2-bin libzmq3-dev`
5. Install bundler and all the gems 
    - Ubuntu - `sudo gem install bundler` then  `bundle install`



### Creating your Chat bot 


1. Create a new LITA instance 
    - `lita new mybotwalle` 
1. Configure your  BOT for HIPCHAT
    - Open : mybotwalle/lita_config.rb and configure parameters to the chat platform. 
1. Copy brushmetal.css into LITA instance directory
    - cp /var/lib/gems/2.3.0/gems/lita-trisul-0.2.4/lib/lita/handlers/trisul.rb /lita-trisul/mybotwalle/
1. Require 'trisulrp' in your /var/lib/gems/2.3.0/gems/lita-trisul-0.2.4/lib/lita-trisul.rb file
    - require 'trisulrp'
