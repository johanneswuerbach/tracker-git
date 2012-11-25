RSpec.configure do |config|
  config.run_all_when_everything_filtered = true

  require File.dirname(__FILE__) + '/../lib/tracker_git'
  require 'pivotal_tracker'
end
