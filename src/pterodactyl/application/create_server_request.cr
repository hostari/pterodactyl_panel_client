module Pterodactyl
  class CreateServerRequest
    property name : String
    property user : Int64
    property egg : Int64
    property docker_image : String
    property startup : String
    property environment : Hash(String, String)
    property limits : Hash(String, Int32)
    property feature_limits : Hash(String, Int32)
    property allocation : Hash(String, Int32)
    @options : Hash(Symbol, String)

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
      **body_params
    )
      @options = body_params.to_h
    end

    def as_json : String
      {
        name:           name,
        user:           user,
        egg:            egg,
        docker_image:   docker_image,
        startup:        startup,
        environment:    environment,
        limits:         limits,
        feature_limits: feature_limits,
        allocation:     allocation,
      }.to_h
        .merge(@options)
        .to_json
    end
  end
end
