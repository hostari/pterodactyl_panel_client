module Pterodactyl
  class HttpClient
    property base_url : String
    property token : String

    def initialize(@base_url : String, @token : String)
      @headers = HTTP::Headers{
        "Content-Type"  => "application/json",
        "Accept"        => "application/json",
        "Authorization" => "Bearer #{@token}",
      }
    end

    # Sets the base url. Alias of `base_url=`.
    def set_host(url : String)
      @base_url = url
    end

    # Returns the URI for which this client will make API requests to.
    def uri : URI
      URI.parse(@base_url)
    end

    # Performs a GET request on the path.
    def get(path : String)
      HTTP::Client.new(uri).get(path, headers: @headers)
    end

    # Performs a POST request on the path with a body.
    def post(path : String, body : String = "")
      HTTP::Client.new(uri)
        .post(path, headers: @headers, body: body)
    end

    def patch(path : String, body : String = "")
      HTTP::Client.new(uri)
        .patch(path, headers: @headers, body: body)
    end

    def put(path : String, body : String = "")
      HTTP::Client.new(uri)
        .put(path, headers: @headers, body: body)
    end

    def delete(path : String)
      HTTP::Client.new(uri).delete(path, headers: @headers)
    end
  end
end
