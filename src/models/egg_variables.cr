module Pterodactyl::Models
  module BaseEggVariable
    macro included
      getter name : String
      getter description : String
      getter env_variable : String
      getter default_value : String
      getter server_value : String?
      getter rules : String
    end
  end
end
