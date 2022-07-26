require "active_support/core_ext/integer/time"

# load in the production config
require Rails.root.join("config/environments/production")

Rails.application.configure do
  # override production here
end
