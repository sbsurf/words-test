def file_path(from_root)
  File.expand_path("../#{from_root}", File.dirname(__FILE__))
end

require 'simplecov'
SimpleCov.start
