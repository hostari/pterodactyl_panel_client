module Pterodactyl::Converter
  macro included
    module DataConverter
      def self.from_json(parser) : Array({{@type.name.id}})
        # https://github.com/crystal-lang/crystal/blob/016578f858cd08efc035a9c66a82965efc75321c/src/json/from_json.cr#L450
        json = JSON.build do |builder|
          parser.read_raw(builder)
        end

        raw_response = APIResponse({{@type.name.id}}).from_json json
        raw_response.data.map &.attributes
      end

      def self.to_json(value, builder)
        builder.raw(value.to_s)
      end
    end
  end
end
