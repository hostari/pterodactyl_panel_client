module Pterodactyl::Models
  struct ClientAllocation
    include JSON::Serializable

    getter id : Int64
    getter ip : String
    getter ip_alias : String
    getter port : Int64
    getter notes : String?
    getter is_default : Bool
  end

  struct AppAllocation
    include JSON::Serializable

    getter id : Int64
    getter ip : String
    getter alias : String?
    getter port : Int64
    getter notes : String?
    getter assigned : Bool
  end
end
