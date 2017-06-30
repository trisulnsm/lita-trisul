Gem::Specification.new do |spec|
  spec.name          = "lita-trisul"
  spec.version       = "0.2.5"
  spec.authors       = ["Krishna"]
  spec.email         = ["info@unleashnetworks.com"]
  spec.description   = "Lita chatops to Trisul Network Analytics"
  spec.summary       = "Chatbot interface to network traffic and security monitoring"
  spec.homepage      = "https://github.com/trisulnsm/lita-trisul"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.7"
  spec.add_runtime_dependency "trisulrp"
  spec.add_runtime_dependency "ffi-rzmq"
  spec.add_runtime_dependency "builder"
  spec.add_runtime_dependency "gerbilcharts"

#Uncomment to use the IRC adapter

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
end
