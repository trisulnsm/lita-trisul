require "lita"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/handlers/trisul"

Lita::Handlers::Trisul.template_root File.expand_path(
  File.join("..", "..", "templates"),
 __FILE__
)
require "lita/handlers/lita-hello"
require "lita/handlers/lita-gerbile"
require 'trisulrp'
