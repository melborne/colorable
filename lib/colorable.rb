require "colorable/version"

module Colorable
  # Your code goes here...
end

%w(converter).each { |lib| require_relative "colorable/" + lib }
