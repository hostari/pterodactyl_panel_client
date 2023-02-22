module Pterodactyl::Models
  struct ResourceUsage
    include JSON::Serializable

    getter current_state : String
    getter is_suspended : Bool
    getter resources : Resources
  end

  struct Resources
    include JSON::Serializable

    getter memory_bytes : Int64
    getter cpu_absolute : Float64
    getter disk_bytes : Int64
    @[JSON::Field(key: "network_rx_bytes")]
    getter received_bytes : Int64
    @[JSON::Field(key: "network_tx_bytes")]
    getter transmitted_bytes : Int64
    getter uptime : Int64
  end
end
