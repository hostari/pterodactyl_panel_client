class Pterodactyl::ApplicationSdk
  def initialize(@host : String, @application_token : String)
    @client = HttpClient.new(@host, @application_token)
  end

  private def base_path
    "/api/application"
  end

  private def build_path(resource_path)
    "#{base_path}#{resource_path}"
  end

  def create_user(
    email : String,
    username : String,
    first_name : String,
    last_name : String
  )
    result = @client.post(build_path("/users"), {email: email, username: username, first_name: first_name, last_name: last_name}.to_json)
    Models::Data(Models::User).from_json(result.body).attributes
  end

  def list_locations : Array(Models::Location)
    result = @client.get(build_path("/locations"))
    locations = Models::APIResponse(Models::Location).from_json(result.body)
    locations.data.map &.attributes
  end

  def get_location(id : Int32 | Int64 | String) : Models::Location
    result = @client.get(build_path("/locations/#{id}"))
    Models::Data(Models::Location).from_json(result.body).attributes
  end

  def list_servers
    result = @client.get(build_path("/servers"))
    servers = Models::APIResponse(Models::ApplicationServer).from_json result.body
    servers.data.map &.attributes
  end

  def get_server(id : Int32 | Int64 | String)
    result = @client.get(build_path("/servers/#{id}"))
    Models::Data(Models::ApplicationServer).from_json(result.body).attributes
    # TODO: handle 404
  end

  def update_server_details(
    id : Int32 | Int64 | String,
    name : String,
    user : Int32,
    external_id : String? = nil,
    description : String? = nil
  )
    result = @client.patch(build_path("/servers/#{id}/details"), body: {id: id.to_i64, name: name, user: user, external_id: external_id, description: description}.to_json)
    Models::Data(Models::ApplicationServer).from_json(result.body).attributes
  end

  def update_server_build(
    id : Int32 | Int64 | String,
    allocation : Int32,
    feature_limits : Hash(String, Int32),
    memory : Int32 = nil,
    swap : Int32 = nil,
    disk : Int32 = nil,
    io : Int32 = nil,
    cpu : Int32 = nil,
    threads : String? = nil
  )
    result = @client.patch(build_path("/servers/#{id}/build"), body: {id: id.to_i64, allocation: allocation, feature_limits: feature_limits, memory: memory, swap: swap, disk: disk, io: io, cpu: cpu, threads: threads}.to_json)
    Models::Data(Models::ApplicationServer).from_json(result.body).attributes
  end

  def update_server_startup(
    startup : String,
    egg : Int32,
    image : String,
    skip_scripts : Bool,
    environment : Hash(String, String) = Hash.new
  )
    result = @client.patch(build_path("/servers/#{id}/startup"), body: {startup: startup, egg: egg, image: image, skip_scripts: skip_scripts, environment: environment}.to_json)
    Models::Data(Models::ApplicationServer).from_json(result.body).attributes
  end

  def create_server(create_server_request : CreateServerRequest)
    result = @client.post(build_path("/servers"), body: create_server_request.as_json)
    Models::Data(Models::ApplicationServer).from_json(result.body).attributes
  end

  def suspend_server(id : Int64 | Int32 | String)
    # returns a 204
    @client.post(build_path("/servers/#{id}/suspend"))
  end

  def unsuspend_server(id : Int64 | Int32 | String)
    # returns a 204
    @client.post(build_path("/servers/#{id}/unsuspend"))
  end

  def reinstall_server(id : Int64 | Int32 | String)
    # returns a 204
    @client.post(build_path("/servers/#{id}/reinstall"))
  end

  def delete_server(id : Int64 | Int32 | String, force : Bool = false)
    # returns a 204
    if force
      @client.delete(build_path("/server/#{id}"))
    else
      @client.delete(build_path("/server/#{id}/force"))
    end
  end

  def list_nests : Array(Models::Nest)
    result = @client.get(build_path("/nests"))
    nests = Models::APIResponse(Models::Nest).from_json result.body
    nests.data.map &.attributes
  end

  def get_nest(id : Int32 | Int64 | String)
    result = @client.get(build_path("/nests/#{id}"))
    Models::Data(Models::Nest).from_json(result.body).attributes
  end

  def get_eggs(id : Int64 | Int32 | String)
    result = @client.get(build_path("/nests/#{id}/eggs"))
    eggs = Models::APIResponse(Models::Egg).from_json result.body
    eggs.data.map &.attributes
  end

  def get_egg(egg_id : Int64 | Int32 | String, nest_id : Int32 | Int64 | String)
    result = @client.get(build_path("/nests/#{nest_id}/eggs/#{egg_id}"))
    Models::Data(Models::Egg).from_json(result.body).attributes
  end
end
