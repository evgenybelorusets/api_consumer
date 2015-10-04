# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

require File.expand_path('../../lib/patches/cancan', __FILE__)
