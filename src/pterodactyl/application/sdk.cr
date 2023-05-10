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
    last_name : String,
    password : String
  )
    result = @client.post(build_path("/users"), {email: email, username: username, first_name: first_name, last_name: last_name, password: password}.to_json)
    normalized_data = Models::Data(Models::User).from_json(result.body)
    user = normalized_data.attributes
    if meta = normalized_data.meta
      user.client_api_key = meta["token"].as_s
    end

    user
  rescue e : APIError
    raise e
  end

  def list_locations : Array(Models::Location)
    result = @client.get(build_path("/locations"))
    locations = Models::APIResponse(Models::Location).from_json(result.body)
    locations.data.map &.attributes
  rescue e : APIError
    raise e
  end

  def get_location(id : Int32 | Int64 | String) : Models::Location
    result = @client.get(build_path("/locations/#{id}"))
    Models::Data(Models::Location).from_json(result.body).attributes
  rescue e : APIError
    raise e
  end

  def list_servers
    result = @client.get(build_path("/servers"))
    servers = Models::APIResponse(Models::ApplicationServer).from_json result.body
    servers.data.map &.attributes
  rescue e : APIError
    raise e
  end

  def get_server(id : Int32 | Int64 | String) : Models::ApplicationServer
    result = @client.get(build_path("/servers/#{id}"))
    Models::Data(Models::ApplicationServer).from_json(result.body).attributes
  rescue e : APIError
    raise e
  end

  def update_server_details(
    id : Int32 | Int64 | String,
    name : String,
    user : Int32,
    external_id : String? = nil,
    description : String? = nil
  ) : Models::ApplicationServer
    result = @client.patch(build_path("/servers/#{id}/details"), body: {id: id.to_i64, name: name, user: user, external_id: external_id, description: description}.to_json)
    Models::Data(Models::ApplicationServer).from_json(result.body).attributes
  rescue e : APIError
    raise e
  end

  def update_server_startup(id : String | Int32 | Int64, body : Body::UpdateServerStartup)
    result = @client.patch(build_path("/servers/#{id}/startup"), body: body.to_json)
    Models::Data(Models::ApplicationServer).from_json(result.body).attributes
  rescue e : APIError
    raise e
  end

  def create_server(create_server_request : CreateServerRequest)
    result = @client.post(build_path("/servers"), body: create_server_request.as_json)
    Models::Data(Models::ApplicationServer).from_json(result.body).attributes
  rescue e : APIError
    raise e
  end

  def suspend_server(id : Int64 | Int32 | String)
    # returns a 204
    @client.post(build_path("/servers/#{id}/suspend"))
  rescue e : APIError
    raise e
  end

  def unsuspend_server(id : Int64 | Int32 | String)
    # returns a 204
    @client.post(build_path("/servers/#{id}/unsuspend"))
  rescue e : APIError
    raise e
  end

  def reinstall_server(id : Int64 | Int32 | String)
    # returns a 204
    @client.post(build_path("/servers/#{id}/reinstall"))
  rescue e : APIError
    raise e
  end

  def delete_server(id : Int64 | Int32 | String, force : Bool = false)
    # returns a 204
    if force
      @client.delete(build_path("/servers/#{id}/force"))
    else
      @client.delete(build_path("/servers/#{id}"))
    end
  rescue e : APIError
    raise e
  end

  def update_server_build(id : Int64 | Int32 | String, body : Body::UpdateServerBuild)
    result = @client.patch(build_path("/servers/#{id}/build"), body: body.to_json)
    Models::Data(Models::ApplicationServer).from_json(result.body).attributes
  rescue e : APIError
    raise e
  end

  def list_nests : Array(Models::Nest)
    result = @client.get(build_path("/nests"))
    nests = Models::APIResponse(Models::Nest).from_json result.body
    nests.data.map &.attributes
  rescue e : APIError
    raise e
  end

  def get_nest(id : Int32 | Int64 | String, relationships : Array(String) = [] of String)
    params = ""
    params = "?include=#{relationships.join(",")}" unless relationships.empty?

    result = @client.get(build_path("/nests/#{id}#{params}"))
    Models::Data(Models::Nest).from_json(result.body).attributes
  rescue e : APIError
    raise e
  end

  def get_eggs(id : Int64 | Int32 | String)
    result = @client.get(build_path("/nests/#{id}/eggs"))
    eggs = Models::APIResponse(Models::Egg).from_json result.body
    eggs.data.map &.attributes
  rescue e : APIError
    raise e
  end

  def get_egg(egg_id : Int64 | Int32 | String, nest_id : Int32 | Int64 | String, relationships : Array(String) = [] of String)
    params = ""
    params = "?include=#{relationships.join(",")}" unless relationships.empty?

    result = @client.get(build_path("/nests/#{nest_id}/eggs/#{egg_id}#{params}"))
    Models::Data(Models::Egg).from_json(result.body).attributes
  rescue e : APIError
    raise e
  end

  def get_nodes(params : Array(NodeParam) = [] of NodeParam)
    param_str = ""
    if !params.empty?
      param_str = "?include=" + params.map(&.to_str).join(",")
    end
    res = @client.get build_path("/nodes#{param_str}")
    model = Models::APIResponse(Models::Node).from_json res.body
    model.data.map &.attributes
  rescue e : APIError
    raise e
  end

  def get_node(node_id : Int64 | Int32 | String)
    res = @client.get build_path("/nodes/#{node_id}")
    Models::Data(Models::Node).from_json(res.body).attributes
  rescue e : APIError
    raise e
  end

  def get_allocations(node_id : Int64 | Int32 | String, page : Int64 = 1)
    result = @client.get(build_path("/nodes/#{node_id}/allocations?page=#{page}"))
    allocs = Models::APIResponse(Models::AppAllocation).from_json result.body
    allocs.data.map &.attributes
  rescue e : APIError
    raise e
  end

  def create_allocation(node_id : Int64 | Int32 | String, ip : String, ports : Array(String) | Array(Int64) | Array(Int32))
    payload = {"ip" => ip, "ports" => ports.map(&.to_s)}
    # 204 response
    @client.post(build_path("/nodes/#{node_id}/allocations"), payload.to_json)
  rescue e : APIError
    raise e
  end

  def delete_allocation(node_id : Int64 | Int32 | String, allocation_id : Int64 | Int32 | String)
    # 204 response
    @client.delete(build_path("/nodes/#{node_id}/allocations/#{allocation_id}"))
  rescue e : APIError
    raise e
  end
end
