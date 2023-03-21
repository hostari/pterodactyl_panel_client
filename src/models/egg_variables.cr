module Pterodactyl::Models
  struct EggVariable
    include JSON::Serializable
    include Pterodactyl::Converter

    getter name : String
    getter description : String
    getter env_variable : String
    getter default_value : String
    getter server_value : String
    getter is_editable : Bool
    getter rules : String
  end
end
