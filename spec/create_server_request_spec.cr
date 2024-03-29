require "./spec_helper"

describe Pterodactyl::CreateServerRequest do
  it "create a server request" do
    req = Pterodactyl::CreateServerRequest.new(
      name: "test",
      user: 123.to_i64,
      egg: 1.to_i64,
      docker_image: "image",
      startup: "start",
      environment: {"env" => "val"},
      limits: {"lim" => 1},
      feature_limits: {"feat" => 3},
      allocation: {
        default:    12,
        additional: [] of Int32,
      },
    )

    req_obj = JSON.parse(req.as_json).as_h
    req_obj["start_on_completion"].should eq(false)
  end
end
