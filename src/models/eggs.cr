module Pterodactyl::Models
  # https://github.com/pterodactyl/panel/blob/develop/app/Models/Egg.php
  struct Egg
    include JSON::Serializable
    include Pterodactyl::Converter

    getter id : Int64
    getter uuid : String
    getter name : String
    @[JSON::Field(key: "nest")]
    getter nest_id : Int64
    getter author : String
    getter description : String?
    getter features : Array(String)?
    getter docker_images : JSON::Any
    getter startup : String
    getter config : Config
    getter script : Script
    getter created_at : Time
    getter updated_at : Time
  end

  struct Config
    include JSON::Serializable

    getter files : JSON::Any?
    getter startup : JSON::Any?
    getter stop : String?
    getter file_denylist : Array(String)?
    getter extends : Int64?
  end

  struct Script
    include JSON::Serializable

    getter privileged : Bool
    getter install : String?
    getter entry : String?
    getter container : String?
    getter extends : Int64?
  end
end
