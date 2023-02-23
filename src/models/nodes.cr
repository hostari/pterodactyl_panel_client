module Pterodactyl::Models
  struct Node
    include JSON::Serializable

    getter id : Int64
    getter uuid : String
    getter public : Bool
    getter name : String
    getter description : String
    getter location_id : Int64
    getter fqdn : String
    getter scheme : String
    getter behind_proxy : Bool
    getter maintenance_mode : Bool
    getter memory : Int64
    getter memory_overallocate : Int64
    getter disk : Int64
    getter disk_overallocate : Int64
    getter daemon_listen : Int64
    getter daemon_sftp : Int64
    getter daemon_base : String
    getter allocated_resources : AllocatedResource
  end

  struct AllocatedResource
    include JSON::Serializable
    getter memory : Int64
    getter disk : Int64
  end
end
