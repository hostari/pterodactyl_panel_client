module Pterodactyl::Models
  struct APIResponse(T)
    include JSON::Serializable

    getter data : Array(Data(T))
  end

  struct Data(T)
    include JSON::Serializable

    getter object : String
    getter attributes : T
    getter meta : JSON::Any?

    def self.from_json(json : JSON::Any)
      data = new
      data.meta = json["meta"]
      data
    end
  end
end
