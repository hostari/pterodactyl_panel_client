module Pterodactyl
  class HttpClient
    property base_url : String
    property token : String

    HTTP_METHODS = %w{get delete post put patch}

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

    {% for method in Pterodactyl::HttpClient::HTTP_METHODS %}
      # Performs a {{method.id.upcase}} on the path with the given *body*
      def {{method.id}}(path : String, body : String = "") : HTTP::Client::Response
        res = HTTP::Client.new(uri)
          .{{method.id}}(path, headers: @headers, body: body)

        if res.status_code >= 400
          error = Models::ErrorList(Models::Error).from_json res.body
          raise APIError.new(error.errors[0])
        end

        res
      end
    {% end %}
  end
end
