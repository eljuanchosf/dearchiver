require "dearchiver/processor"
require "dearchiver/version"

module Dearchiver

  class << self
    # Shorthand to Dearchiver::Processor.new
    #
    # @return [Dearchiver::Processor]
    #
    def new(options={})
      Dearchiver::Processor.new(options)
    end
  end
end
