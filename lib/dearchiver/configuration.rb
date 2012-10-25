module Dearchiver
  module Configuration
    @@logger = false
    @@fetch_async_responses = true

    # Set logger mode
    #
    # value - Enable/disable logger
    #
    def log_requests= (value)
      @@logger = value == true
    end

    # Return current logger state
    #
    def log_requests
      @@logger
    end
  end
end