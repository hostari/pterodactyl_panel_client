require "./spec_helper"

describe Pterodactyl::ClientSdk do
  host = "http://137.184.187.126"
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
    server.variables[0].env_variable.should eq("SERVER_NAME")
    server.should be_a(Pterodactyl::Models::ClientServer)
  end

  it "raises an error with invalid email address" do
    WebMockWrapper.client_stub(:put, "update_email_error.json", "/account/email", 422)

    client = Pterodactyl::ClientSdk.new(host, "client_token")
    expect_raises(Pterodactyl::APIError, /The email must be a valid email address/) do
      client.update_email("invalidemail")
    end
  end

  it "retrieve server allocations" do
    WebMockWrapper.client_stub(:get, "get_client_allocations.json", "/servers/78095333/network/allocations")

    client = Pterodactyl::ClientSdk.new(host, "client_token")
    allocs = client.get_allocations("78095333")

    allocs[0].ip.should eq("209.236.114.150")
    allocs.should be_a(Array(Pterodactyl::Models::ClientAllocation))
  end

  it "get server resource usage" do
    WebMockWrapper.client_stub(:get, "resource_usage.json", "/servers/78095333/resources")

    client = Pterodactyl::ClientSdk.new(host, "client_token")
    usage = client.get_server_resource_usage("78095333")

    usage.current_state.should eq("running")
    usage.resources.memory_bytes.should eq(2509082624)
    usage.should be_a(Pterodactyl::Models::ResourceUsage)
  end

  it "update startup variable" do
    WebMockWrapper.client_stub(:put, "update_variable_success.json", "/servers/78095333/startup/variable")
    new_var_value = "Test edit name"

    client = Pterodactyl::ClientSdk.new(host, "client_token")
    var = client.update_variable("78095333", "SERVER_NAME", new_var_value)

    var.server_value.should eq(new_var_value)
    var.should be_a(Pterodactyl::Models::EggVariable)
  end

  it "list startup variables" do
    WebMockWrapper.client_stub(:get, "variable_list.json", "/servers/78095333/startup")

    client = Pterodactyl::ClientSdk.new(host, "client_token")
    vars = client.get_variables("78095333")

    vars.size.should eq(3)
    vars.should be_a(Array(Pterodactyl::Models::EggVariable))
  end
end
