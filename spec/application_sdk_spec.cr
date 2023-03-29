require "./spec_helper"

describe Pterodactyl::ApplicationSdk do
  host = "http://137.184.187.126"

  it "succesfully creates a user" do
    WebMockWrapper.application_stub(:post, "create_user_success.json", "/users")

    app = Pterodactyl::ApplicationSdk.new(host, "client_token")
    user = app.create_user(
      email: "example10@example.com",
      username: "exampleuser",
      first_name: "Example",
      last_name: "User"
    )

    user.username.should eq("exampleuser")
    user.client_api_key.should eq("api_token_1234")
    user.should be_a(Pterodactyl::Models::User)
  end

  it "raises an error on invalid email" do
    WebMockWrapper.application_stub(:post, "create_user_failure.json", "/users", 422)

    app = Pterodactyl::ApplicationSdk.new(host, "client_token")
    expect_raises(Pterodactyl::APIError) do
      app.create_user(
        email: "example10example.com",
        username: "exampleuser",
        first_name: "Example",
        last_name: "User"
      )
    end
  end

  describe "Nests" do
    it "retrieves a nest" do
      WebMockWrapper.application_stub(:get, "nest_details.json", "/nests/7")

      app = Pterodactyl::ApplicationSdk.new(host, "client_token")
      nest = app.get_nest(7)

      nest.author.should eq("support@hostari.com")
      nest.relationships.should be_nil
      nest.should be_a(Pterodactyl::Models::Nest)
    end

    it "retrieves a nest with relationships" do
      WebMockWrapper.application_stub(:get, "nest_details_with_relationship.json", "/nests/7?include=eggs,servers")

      app = Pterodactyl::ApplicationSdk.new(host, "client_token")
      nest = app.get_nest(7, ["eggs", "servers"])

      nest.relationships.try &.eggs.try &.size.should eq(1)
      nest.relationships.try &.servers.try &.size.should eq(2)
      nest.should be_a(Pterodactyl::Models::Nest)
    end
  end

  describe "Eggs" do
    it "get list of eggs" do
      WebMockWrapper.application_stub(:get, "get_egg_list.json", "/nests/1/eggs")

      app = Pterodactyl::ApplicationSdk.new(host, "client_token")
      eggs = app.get_eggs(1)

      eggs.size.should eq(5)
      eggs[0].name.should eq("Paper")
      eggs.should be_a(Array(Pterodactyl::Models::Egg))
    end

    it "get egg" do
      WebMockWrapper.application_stub(:get, "get_egg.json", "/nests/1/eggs/1")

      app = Pterodactyl::ApplicationSdk.new(host, "client_token")
      egg = app.get_egg(1, 1)

      egg.docker_images.first_value.should eq("ghcr.io/pterodactyl/yolks:java_8")
      egg.author.should eq("parker@pterodactyl.io")
      egg.should be_a(Pterodactyl::Models::Egg)
    end

    it "retrieves an egg with relationships" do
      WebMockWrapper.application_stub(:get, "egg_with_relationship.json", "/nests/7/eggs/19?include=nest,servers,variables")

      app = Pterodactyl::ApplicationSdk.new(host, "client_token")
      egg = app.get_egg(19, 7, ["nest", "servers", "variables"])

      egg.relationships.try &.nest.try &.name.should eq("Project Zomboid")
      egg.should be_a(Pterodactyl::Models::Egg)
    end
  end

  it "raises a not found error on unavailable resource" do
    WebMockWrapper.application_stub(:get, "404_error.json", "/nests/404/eggs", 404)

    app = Pterodactyl::ApplicationSdk.new(host, "client_token")
    expect_raises(Pterodactyl::APIError, /The requested resource could not be found on the server/) do
      app.get_eggs(404)
    end
  end

  it "retrieves list of nodes" do
    WebMockWrapper.application_stub(:get, "get_nodes.json", "/nodes")

    app = Pterodactyl::ApplicationSdk.new(host, "client_token")
    nodes = app.get_nodes

    nodes[0].uuid.should eq("5b5fd79b-9bbc-4b4d-ac40-48dfa501a0c9")
    nodes.should be_a(Array(Pterodactyl::Models::Node))
  end

  it "retrieves a node" do
    WebMockWrapper.application_stub(:get, "get_node.json", "/nodes/1")

    app = Pterodactyl::ApplicationSdk.new(host, "client_token")
    node = app.get_node(1)

    node.uuid.should eq("5b5fd79b-9bbc-4b4d-ac40-48dfa501a0c9")
    node.should be_a(Pterodactyl::Models::Node)
  end

  it "retrieves allocations given a node" do
    WebMockWrapper.application_stub(:get, "get_app_allocations.json", "/nodes/1/allocations?page=1")

    app = Pterodactyl::ApplicationSdk.new(host, "client_token")
    allocs = app.get_allocations(1)

    allocs[0].port.should eq(40051)
    allocs.should be_a(Array(Pterodactyl::Models::AppAllocation))
  end

  it "retrieves page 2" do
    WebMockWrapper.application_stub(:get, "get_app_allocations_page_2.json", "/nodes/1/allocations?page=2")

    app = Pterodactyl::ApplicationSdk.new(host, "client_token")
    allocs = app.get_allocations(1, 2)

    allocs[0].port.should eq(10000)
    allocs.should be_a(Array(Pterodactyl::Models::AppAllocation))
  end
end
