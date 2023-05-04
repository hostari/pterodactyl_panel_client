module Pterodactyl::Body
  struct UpdateServerBuild
    include JSON::Serializable

    property allocation : Int32
    property limits : Models::Limits
    property feature_limits : Models::FeatureLimits
    property add_allocations : Array(Int32) = [] of Int32
  end
end
