# Allowable include parameters when querying on certain endpoints
#
# ```
# app = Pterodactyl::ApplicationSdk.new(host, "client_token")
# nodes = app.get_nodes([Pterodactyl::NodeParam::Location])
# ```
module Pterodactyl
  enum NodeParam
    Allocations
    Location
    Servers

    def to_str
      self.to_s.downcase
    end
  end
end
