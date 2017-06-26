Lita.configure do |config|
  # The name your robot will use.
  config.robot.name = "Wallee"

  # The locale code for the language to use.
  # config.robot.locale = :en

  # The severity of messages to log. Options are:
  # :debug, :info, :warn, :error, :fatal
  # Messages at the selected level and above will be logged.
  config.robot.log_level = :info

  # An array of user IDs that are considered administrators. These users
  # the ability to add and remove other users from authorization groups.
  # What is considered a user ID will change depending on which adapter you use.
  # config.robot.admins = ["1", "2"]

  # The adapter you want to connect with. Make sure you've added the
  # appropriate gem to the Gemfile.
  config.robot.adapter = :hipchat

  ## Example: Set options for the chosen adapter.
  # config.adapter.username = "myname"
  # config.adapter.password = "secret"

  ## Example: Set options for the Redis connection.
  # config.redis.host = "127.0.0.1"
  # config.redis.port = 1234

  ## Example: Set configuration for any loaded handlers. See the handler's
  ## documentation for options.
  # config.handlers.some_handler.some_config_key = "value"

  ## Example: Set configuration for any loaded handlers. See the handler's
  ## documentation for options.

  # Sample HIPCHAT confirtaion
  config.adapters.hipchat.jid = "[INSERT-XMPP-HIPCHAT-KEY]@chat.hipchat.com"
  config.adapters.hipchat.password = "[INSERT-PASSWORD]"
  config.adapters.hipchat.debug = false
  config.adapters.hipchat.rooms = :all
  config.http.port=9000
  config.http.host="[INSERT-LITA-TRISUL-HOSTNAME-OR-IP]"
  config.robot.alias = "/"
  config.robot.admins =  "[INSERT-XMPP-HIPCHAT-KEY]@chat.hipchat.com"


end
