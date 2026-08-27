module Pterodactyl
  class HttpClient
    property base_url : String
    property token : String
    property use_content : Bool

    HTTP_METHODS = %w{get delete post put patch}

    def initialize(@base_url : String, @token : String, @use_content : Bool = true)
      if @use_content
        @headers = HTTP::Headers{
          "Content-Type"  => "application/json",
          "Accept"        => "application/json",
          "Authorization" => "Bearer #{@token}",
        }
      else
        @headers = HTTP::Headers{
          "Accept"        => "application/json",
          "Authorization" => "Bearer #{@token}",
        }
      end
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
          error = parse_error(res)
          raise APIError.new(error, res.status_code, res.body)
        end

        res
      end
    {% end %}

    private def parse_error(response : HTTP::Client::Response) : Models::Error
      errors = Models::ErrorList(Models::Error).from_json(response.body).errors
      errors.first? || fallback_error(response.status_code)
    rescue
      fallback_error(response.status_code)
    end

    private def fallback_error(status_code : Int32) : Models::Error
      Models::Error.from_json({
        "code"   => "InvalidErrorResponse",
        "status" => status_code.to_s,
        "detail" => "Panel returned HTTP #{status_code} with an invalid error response.",
      }.to_json)
    end
  end
end
