module Pterodactyl::Models
  struct Nest
    include JSON::Serializable

    getter id : Int64
    getter uuid : String
    getter author : String
    getter name : String
    getter description : String?
    getter created_at : Time
    getter updated_at : Time
    getter relationships : Relationships?
  end

  struct Relationships
    include JSON::Serializable

    @[JSON::Field(converter: Pterodactyl::Models::Egg::DataConverter)]
    getter eggs : Array(Egg)
    @[JSON::Field(converter: Pterodactyl::Models::ApplicationServer::DataConverter)]
    getter servers : Array(ApplicationServer)?
  end
end
