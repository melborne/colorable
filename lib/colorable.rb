require "colorable/version"

module Colorable
  # Your code goes here...
end

%w(system_extension converter color).each { |lib| require_relative "colorable/" + lib }
