module Pterodactyl::Body
  struct UpdateServerStartup
    include JSON::Serializable

    property startup : String
    property environment : Hash(String, String)
    property egg : Int64
    property image : String
  end
end
