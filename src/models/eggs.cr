module Pterodactyl::Models
  # https://github.com/pterodactyl/panel/blob/develop/app/Models/Egg.php
  struct Egg
    include JSON::Serializable

    module DataConverter
      def self.from_json(parser) : Array(Egg)
        # https://github.com/crystal-lang/crystal/blob/016578f858cd08efc035a9c66a82965efc75321c/src/json/from_json.cr#L450
        json = JSON.build do |builder|
          parser.read_raw(builder)
        end

        raw_response = APIResponse(Egg).from_json json
        raw_response.data.map &.attributes
      end

      def self.to_json(value, builder)
        builder.raw(value.to_s)
      end
    end

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
