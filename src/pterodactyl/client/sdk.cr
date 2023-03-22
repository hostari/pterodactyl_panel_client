module Pterodactyl
  class ClientSdk
    getter host : String

    def initialize(@host : String, @client_token : String)
      @client = HttpClient.new(@host, @client_token)
    end

    def get_servers : Array(Models::ClientServer)
      res = @client.get(base_path)
      model = Models::APIResponse(Models::ClientServer).from_json res.body

      model.data.map &.attributes
    rescue e : APIError
      raise e
    end

    def get_server_details(identifier : String) : Models::ClientServer
      res = @client.get build_path("/servers/#{identifier}")
      server = Models::Data(Models::ClientServer).from_json res.body
      server.attributes
    rescue e : APIError
      raise e
    end

    def get_account_details : Models::AccountDetails
      res = @client.get build_path("/account")
      user = Models::Data(Models::AccountDetails).from_json res.body
      user.attributes
    rescue e : APIError
      raise e
    end

    def update_email(email : String)
      payload = {"email" => email, "password" => "password"}
      @client.put build_path("/account/email"), body: payload.to_json
    rescue e : APIError
      raise e
    end

    def get_allocations(identifier : String) : Array(Models::ClientAllocation)
      res = @client.get build_path("/servers/#{identifier}/network/allocations")
      allocations = Models::APIResponse(Models::ClientAllocation).from_json res.body

      allocations.data.map &.attributes
    rescue e : APIError
      raise e
    end

    def assign_allocation(server : Models::ClientServer) : Models::ClientAllocation
      res = @client.post build_path("/servers/#{server.identifier}/network/allocations")
      allocation = Models::Data(Models::ClientAllocation).from_json res.body
      allocation.attributes
    rescue e : APIError
      raise e
    end

    def set_allocation_notes(server : Models::ClientServer, notes : String, allocation_id : Int64) : Models::ClientAllocation
      payload = {"notes" => notes}
      res = @client.post base_path("/servers/#{server.identifier}/network/allocations/#{allocation_id}"), payload.to_json
      allocation = Models::Data(Models::ClientAllocation).from_json res.body
      allocation.attributes
    rescue e : APIError
      raise e
    end

    def set_primary_allocation(server : Models::ClientServer, allocation_id : Int64) : Models::ClientAllocation
      res = @client.post base_path("/servers/#{server.identifier}/network/allocations/#{allocation_id}/primary")
      allocation = Models::Data(Models::ClientAllocation).from_json res.body
      allocation.attributes
    rescue e : APIError
      raise e
    end

    def unassign_allocation(server : Models::ClientServer, allocation_id : Int64)
      @client.delete base_path("/servers/#{server.identifier}/network/allocations/#{allocation_id}")
    rescue e : APIError
      raise e
    end

    def get_backups(server_identifier : String) : Array(Models::Backup)
      res = @client.get build_path("/servers/#{server_identifier}/backups")
      backups = Models::APIResponse(Models::Backup).from_json res.body
      backups.data.map &.attributes
    rescue e : APIError
      raise e
    end

    def create_backup(server_identifier : String) : Models::Backup
      res = @client.post build_path("/servers/#{server_identifier}/backups")
      backup = Models::Data(Models::Backup).from_json res.body
      backup.attributes
    rescue e : APIError
      raise e
    end

    def get_backup(server_identifier : String, backup_uuid : String) : Models::Backup
      res = @client.get build_path("/servers/#{server_identifier}/backups/#{backup_uuid}")
      backup = Models::Data(Models::Backup).from_json res.body
      backup.attributes
    rescue e : APIError
      raise e
    end

    def backup_download_url(server_identifier : String, backup_uuid : String) : String
      res = @client.get build_path("/servers/#{server_identifier}/backups/#{backup_uuid}/download")
      backup = Models::Data(Models::BackupDownloadable).from_json res.body
      backup.attributes.url
    rescue e : APIError
      raise e
    end

    def delete_backup(server_identifier : String, backup_uuid : String)
      @client.delete build_path("/servers/#{server_identifier}/backups/#{backup_uuid}")
    rescue e : APIError
      raise e
    end

    def rename_server(server_identifier : String, name : String)
      payload = {"name" => name}
      @client.post build_path("/servers/#{server_identifier}/settings/rename"), payload.to_json
    rescue e : APIError
      raise e
    end

    def reinstall_server(server_identifier : String)
      @client.post build_path("/servers/#{server_identifier}/settings/reinstall")
    rescue e : APIError
      raise e
    end

    def websocket_credentials(server_identifier : String) : Models::WebsocketCredentials
      res = @client.get build_path("/servers/#{server_identifier}/websocket")
      creds = Models::APIResponse(Models::WebsocketCredentials).from_json res.body
      creds.data
    rescue e : APIError
      raise e
    end

    def get_server_resource_usage(server_identifier : String)
      res = @client.get build_path("/servers/#{server_identifier}/resources")
      usage = Models::Data(Models::ResourceUsage).from_json res.body
      usage.attributes
    rescue e : APIError
      raise e
    end

    def send_command(server_identifier : String, command : String)
      payload = {"command" => command}
      @client.post build_path("/servers/#{server_identifier}/command"), payload.to_json
    rescue e : APIError
      raise e
    end

    def change_server_state(server_identifier : String, signal : String)
      payload = {"signal" => signal}
      @client.post build_path("/servers/#{server_identifier}/power"), payload.to_json
    rescue e : APIError
      raise e
    end

    def update_variable(server_identifier : String, key : String, value : String) : Pterodactyl::Models::ClientServer::EggVariable
      payload = {"key" => key, "value" => value}
      res = @client.put build_path("/servers/#{server_identifier}/startup/variable"), payload.to_json
      variable = Models::Data(Models::ClientServer::EggVariable).from_json res.body
      variable.attributes
    rescue e : APIError
      raise e
    end

    def get_variables(server_identifier : String) : Array(Models::ClientServer::EggVariable)
      res = @client.get build_path("/servers/#{server_identifier}/startup")
      variables = Models::APIResponse(Models::ClientServer::EggVariable).from_json res.body
      variables.data.map &.attributes
    rescue e : APIError
      raise e
    end

    private def base_path
      "/api/client"
    end

    private def build_path(resource_path)
      "#{base_path}#{resource_path}"
    end
  end
end
