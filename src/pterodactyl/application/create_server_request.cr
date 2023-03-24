module Pterodactyl
  class CreateServerRequest
    property name : String
    property user : Int64
    property egg : Int64
    property docker_image : String
    property startup : String
    property environment : Hash(String, String)
    property limits : Hash(String, Int32 | Int64)
    property feature_limits : Hash(String, Int32 | Int64)
    property allocation : Hash(String, Int32 | Int64)
    property start_on_completion : Bool
    property skip_scripts : Bool

    def initialize(
      @name : String,
      @user : Int64,
      @egg : Int64,
      @docker_image : String,
      @startup : String,
      @environment : Hash(String, String),
      @limits : Hash(String, Int32),
      @feature_limits : Hash(String, Int32),
      @allocation : Hash(String, Int32),
      @start_on_completion : Bool = false,
      @skip_scripts : Bool = false
    )
    end

    def as_json : String
      {
        name:                name,
        user:                user,
        egg:                 egg,
        docker_image:        docker_image,
        startup:             startup,
        environment:         environment,
        limits:              limits,
        feature_limits:      feature_limits,
        allocation:          allocation,
        start_on_completion: start_on_completion,
        skip_scripts:        skip_scripts,
      }.to_json
    end
  end
end
