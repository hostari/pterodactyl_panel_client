module Pterodactyl::Body
  struct UpdateServerBuild
    include JSON::Serializable

    property allocation : Int32
    property limits : Models::Limits
    property feature_limits : Models::FeatureLimits
  end
end
