module Pterodactyl
  class APIError < Exception
    getter error : Models::Error
    getter http_status_code : Int32?
    getter response_body : String?

    def initialize(
      @error : Models::Error,
      @http_status_code : Int32? = nil,
      @response_body : String? = nil,
    )
      # initialize the message property of the base Exception class
      super(@error.to_json)
    end
  end
end
