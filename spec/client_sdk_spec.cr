require "./spec_helper"

describe Pterodactyl::ClientSdk do
  host = "137.184.187.126"
  it "retrieve account details" do
    WebMockWrapper.client_stub(:get, "account_details.json", "/account")

    client = Pterodactyl::ClientSdk.new(host, "client_token")
    account = client.get_account_details

    account.email.should eq("example@example.com")
    account.should be_a(Pterodactyl::Models::AccountDetails)
  end

  it "get servers" do
    WebMockWrapper.client_stub(:get, "server_list.json")

    client = Pterodactyl::ClientSdk.new(host, "client_token")
    servers = client.get_servers

    servers[0].feature_limits.databases.should eq(5)
    servers.should be_a(Array(Pterodactyl::Models::ClientServer))
  end

  it "get server details" do
    WebMockWrapper.client_stub(:get, "server_details.json", "/servers/1a7ce997")

    client = Pterodactyl::ClientSdk.new(host, "client_token")
    server = client.get_server_details("1a7ce997")

    server.description.should eq("Matt from Wii Sports")
    server.should be_a(Pterodactyl::Models::ClientServer)
  end

  it "returns an error with invalid email address" do
    WebMockWrapper.client_stub(:put, "update_email_error.json", "/account/email", 422)

    client = Pterodactyl::ClientSdk.new(host, "client_token")
    user = client.update_email("invalidemail")

    if error = user
      error.error_type.should eq("ValidationException")
      error.detail.should eq("The email must be a valid email address.")
      error.should be_a(Pterodactyl::Models::Error)
    end

    user.should be_truthy
  end

  it "get server resource usage" do
    WebMockWrapper.client_stub(:get, "resource_usage.json", "/servers/78095333/resources")

    client = Pterodactyl::ClientSdk.new(host, "client_token")
    usage = client.get_server_resource_usage("78095333")

    usage.current_state.should eq("running")
    usage.resources.memory_bytes.should eq(2509082624)
    usage.should be_a(Pterodactyl::Models::ResourceUsage)
  end
end
