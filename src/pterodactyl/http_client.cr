class Pterodactyl::HttpClient
  property host : String
  property token : String

  def initialize(@host : String, @token : String)
  end

  # Sets the host. Alias of `host=`.
  def set_host(host : String)
    @host = host
  end

  # Returns the base url for which this client will make API requests to.
  def base_url : URI
    if host.starts_with?("localhost")
      URI.parse("http://#{host}")
    else
      URI.parse("https://#{host}")
    end
  end

  # Performs a GET request on the path.
  def get(path : String)
    HTTP::Client.new(base_url).get(path)
  end

  # Performs a POST request on the path with a body.
  def post(path : String, body : String)
    HTTP::Client.new(base_url)
      .post(path, headers: HTTP::Headers{"Content-Type" => "application/json", "Authorization" => "Bearer #{token}"}, body: body)
  end

  def patch(path : String, body : String)
    HTTP::Client.new(base_url)
      .patch(path, headers: HTTP::Headers{"Content-Type" => "application/json", "Authorization" => "Bearer #{token}"}, body: body)
  end

  def delete(path : String)
    HTTP::Client.new(base_url).delete(path)
  end
end
