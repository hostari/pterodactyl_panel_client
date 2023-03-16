require "./spec_helper"

describe Pterodactyl::CreateServerRequest do
  it "accepts other named arguments" do
    req = Pterodactyl::CreateServerRequest.new(
      name: "test",
      user: 123,
      egg: 1,
      docker_image: "image",
      startup: "start",
      environment: {"env" => "val"},
      limits: {"lim" => 1},
      feature_limits: {"feat" => 3},
      allocation: {
        "default" => 12,
      },
      test: "option",
      property_not_in_docs: "23"
    )

    req_obj = JSON.parse(req.as_json).as_h
    req_obj["property_not_in_docs"].should eq("23")
  end
end
