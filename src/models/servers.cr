private module Server
  macro included
    getter uuid : String
    getter identifier : String
    getter name : String
    getter node : String
    getter description : String
    getter limits : Limits
    getter feature_limits : FeatureLimits
  end
end

module Pterodactyl::Models
  struct ClientServer
    include JSON::Serializable
    include Server
  end

  struct ApplicationServer
    include JSON::Serializable
    include Server

    getter id : Int64
    getter external_id : Int64?
    getter suspended : Bool
    getter user : Int64
    getter node : Int64
    getter allocation : Int64
    @[JSON::Field(key: "nest")]
    getter nest_id : Int64
    @[JSON::Field(key: "egg")]
    getter egg_id : Int64
    @[JSON::Field(key: "user")]
    getter user_id : Int64
    # getter pack : Int64 # NOTE: need more info on what a pack is
    getter container : Container
    getter updated_at : Time
    getter created_at : Time
  end

  struct Container
    include JSON::Serializable

    getter startup_command : String
    getter image : String
    # NOTE: Bool or Int?
    getter installed : Int32
    getter environment : JSON::Any

    def self.from_json(json : JSON::Any)
      obj = new
      obj.environment = json["environment"]
      obj
    end
  end

  struct Limits
    include JSON::Serializable

    getter memory : Int32
    getter swap : Int32
    getter disk : Int32
    getter io : Int32
    getter cpu : Int32
  end

  struct FeatureLimits
    include JSON::Serializable

    getter databases : Int32
    getter allocations : Int32
    getter backups : Int32
  end
end
