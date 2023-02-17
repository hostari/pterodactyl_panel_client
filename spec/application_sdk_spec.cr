require "./spec_helper"

describe Pterodactyl::ApplicationSdk do
  host = "137.184.187.126"
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

    egg.author.should eq("parker@pterodactyl.io")
    egg.should be_a(Pterodactyl::Models::Egg)
  end
end
