module Pterodactyl::Models
  struct EggVariable
    include JSON::Serializable

    module EggConverter
      def self.from_json(parser) : Array(EggVariable)
        # https://github.com/crystal-lang/crystal/blob/016578f858cd08efc035a9c66a82965efc75321c/src/json/from_json.cr#L450
        json = JSON.build do |builder|
          parser.read_raw(builder)
        end

        raw_response = APIResponse(EggVariable).from_json json
        raw_response.data.map &.attributes
      end

      def self.to_json(value, builder)
        builder.raw(value.to_s)
      end
    end

    getter name : String
    getter description : String
    getter env_variable : String
    getter default_value : String
    getter server_value : String
    getter is_editable : Bool
    getter rules : String
  end
end
