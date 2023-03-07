require "./spec_helper"

host = "http://137.184.187.126"
client = Pterodactyl::ClientSdk.new(host, "client_token")

describe Pterodactyl::ClientSdk do
  it "retrieve account details" do
    WebMockWrapper.client_stub(:get, "account_details.json", "/account")

    account = client.get_account_details

    account.email.should eq("example@example.com")
    account.should be_a(Pterodactyl::Models::AccountDetails)
  end

  it "get servers" do
    WebMockWrapper.client_stub(:get, "server_list.json")

    servers = client.get_servers

    servers[0].feature_limits.databases.should eq(5)
    servers.should be_a(Array(Pterodactyl::Models::ClientServer))
  end

  it "get server details" do
    WebMockWrapper.client_stub(:get, "server_details.json", "/servers/1a7ce997")

    server = client.get_server_details("1a7ce997")

    server.description.should eq("Matt from Wii Sports")
    server.variables[0].env_variable.should eq("SERVER_NAME")
    server.should be_a(Pterodactyl::Models::ClientServer)
  end

  it "raises an error with invalid email address" do
    WebMockWrapper.client_stub(:put, "update_email_error.json", "/account/email", 422)

    expect_raises(Pterodactyl::APIError, /The email must be a valid email address/) do
      client.update_email("invalidemail")
    end
  end

  it "retrieve server allocations" do
    WebMockWrapper.client_stub(:get, "get_client_allocations.json", "/servers/78095333/network/allocations")

    allocs = client.get_allocations("78095333")

    allocs[0].ip.should eq("209.236.114.150")
    allocs.should be_a(Array(Pterodactyl::Models::ClientAllocation))
  end

  describe "Backups" do
    it "retrieve backups" do
      WebMockWrapper.client_stub(:get, "backup_list.json", "/servers/78095333/backups")

      backups = client.get_backups("78095333")

      backups[0].checksum.should eq("sha1:qwertyuipoqq123")
      backups.should be_a(Array(Pterodactyl::Models::Backup))
    end

    it "successfully creates backups" do
      WebMockWrapper.client_stub(:post, "create_backup_success.json", "/servers/78095333/backups")

      backup = client.create_backup("78095333")

      backup.is_successful.should be_false
      backup.checksum.should eq(nil)
      backup.should be_a(Pterodactyl::Models::Backup)
    end

    it "raises an error when backup limit is reached" do
      WebMockWrapper.client_stub(:post, "backup_limit_reached.json", "/servers/78095333/backups", 400)

      expect_raises(Pterodactyl::APIError) do
        client.create_backup("78095333")
      end
    end

    it "retrieve backup details" do
      backup_uuid = "33f5ebbc-05b5-44a4-92ee-fbe4fed5a336"

      WebMockWrapper.client_stub(:get, "get_backup.json", "/servers/78095333/backups/#{backup_uuid}")
      backup = client.get_backup("78095333", backup_uuid)

      backup.is_successful.should be_true
      backup.checksum.should eq("sha1:akfgjh20437")
      backup.uuid.should eq(backup_uuid)
      backup.should be_a(Pterodactyl::Models::Backup)
    end

    it "retrieve download url" do
      backup_uuid = "33f5ebbc-05b5-44a4-92ee-fbe4fed5a336"

      WebMockWrapper.client_stub(:get, "download_backup.json", "/servers/78095333/backups/#{backup_uuid}/download")
      backup_url = client.backup_download_url("78095333", backup_uuid)

      backup_url.should eq("https://downloadbackup.com")
      backup_url.should be_a(String)
    end
  end

  it "get server resource usage" do
    WebMockWrapper.client_stub(:get, "resource_usage.json", "/servers/78095333/resources")

    usage = client.get_server_resource_usage("78095333")

    usage.current_state.should eq("running")
    usage.resources.memory_bytes.should eq(2509082624)
    usage.should be_a(Pterodactyl::Models::ResourceUsage)
  end

  it "update startup variable" do
    WebMockWrapper.client_stub(:put, "update_variable_success.json", "/servers/78095333/startup/variable")
    new_var_value = "Test edit name"

    var = client.update_variable("78095333", "SERVER_NAME", new_var_value)

    var.server_value.should eq(new_var_value)
    var.should be_a(Pterodactyl::Models::EggVariable)
  end

  it "list startup variables" do
    WebMockWrapper.client_stub(:get, "variable_list.json", "/servers/78095333/startup")

    vars = client.get_variables("78095333")

    vars.size.should eq(3)
    vars.should be_a(Array(Pterodactyl::Models::EggVariable))
  end
end
