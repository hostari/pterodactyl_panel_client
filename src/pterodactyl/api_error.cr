module Pterodactyl
  class APIError < Exception
    getter error : Models::Error
    def initialize(@error : Models::Error)
      # initialize the message property of the base Exception class
      super(@error.to_json)
    end
  end
end
