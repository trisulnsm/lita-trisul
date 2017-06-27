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
  1. Ubuntu - `sudo apt-get install ruby-ffi-rzmq`
4. Install other dependencies  
  1. Ubuntu - `sudo apt-get install build-essential libssl-dev redis-server librsvg2-bin`
5. Install bundler and all the gems 
    - Ubuntu - `sudo gem install bundler` then  `bundle install`



### Creating your Chat bot 



1. Create a new LITA instance 
    - `lita new mybotwalle` 
1. Configure your  BOT for HIPCHAT
    - Open : walle/lita_conf and choose a nick 
  


# There seems to be a bug with gerbil charts
  # To provide a temporary fix against the bug, copy the gerbil.js and brushmetal.css files to the directory to the directory from which the bot is started and then start the bot
  # cp /var/lib/gems/2.3.0/gems/lita-trisul-0.2.0/lib/lita/handlers/gerbil.js .
  # cp /var/lib/gems/2.3.0/gems/lita-trisul-0.2.0/lib/lita/handlers/brushmetal.js .



