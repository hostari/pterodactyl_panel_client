module Pterodactyl::Body
  struct UpdateServerStartup
    include JSON::Serializable

    property startup : String
    property environment : Hash(String, String)
    property egg : Int64
    property image : String
    property skip_scripts : Bool = false
  end
end
