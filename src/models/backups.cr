module Pterodactyl::Models
  struct Backup
    include JSON::Serializable

    getter uuid : String
    getter name : String
    getter is_successful : Bool
    getter is_locked : Bool
    getter ignored_files : Array(String)
    getter checksum : String?
    getter bytes : Int64
    getter created_at : Time
    getter completed_at : Time?
  end

  struct BackupDownloadable
    include JSON::Serializable

    getter url : String
  end
end
