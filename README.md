# lita-trisul

[![Build Status](https://travis-ci.org/kkn1806/lita-trisul.png?branch=master)](https://travis-ci.org/kkn1806/lita-trisul)
[![Coverage Status](https://coveralls.io/repos/kkn1806/lita-trisul/badge.png)](https://coveralls.io/r/kkn1806/lita-trisul)


## Installation

Add lita-trisul to your Lita instance's Gemfile:

``` ruby
gem "lita-trisul"
```

## Configuration

TODO: Describe any configuration attributes the plugin exposes.

## Usage

TODO: Describe the plugin's features and how to use them.



## For developers


Instructions for developers of lita-trisul

1. Fork and then
  1.  Ubuntu -  `git clone https://github.com/trisulnsm/lita-trisul.git`
2. Install ruby  
  1. Ubuntu -  `sudo apt-get install ruby ruby-dev`
3. Install Ruby binding for ZMQ - we use this to connect to Trisul domain 
  1. Ubuntu - `sudo apt-get install ruby-ffi-rzmq`
4. Install other dependencies  
  1. Ubuntu - `sudo apt-get install build-essential libssl-dev redis-server`
5. Install bundler and all the gems 
  1. Ubuntu - `gem install bundler` then  `bundle install`


1 Configure your  BOT for HIPCHAT 
  1. Open : wallee /lita_conf and choose a nick 
  

# Add builder,gerbilcharts and trisulrp gems to the Gemfile and run "bundle install" 
  # gem "trisulrp"
  # gem "gerbilcharts"
  # gem "builder"


# There seems to be a bug with gerbil charts
  # To provide a temporary fix against the bug, copy the gerbil.js and brushmetal.css files to the directory to the directory from which the bot is started and then start the bot
  # cp /var/lib/gems/2.3.0/gems/lita-trisul-0.2.0/lib/lita/handlers/gerbil.js .
  # cp /var/lib/gems/2.3.0/gems/lita-trisul-0.2.0/lib/lita/handlers/brushmetal.js .



