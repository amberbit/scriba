module Scriba
  class Entry
    include Mongoid::Document
    field :severity, type: String
    field :created_at, type: DateTime
    field :message, type: String
    field :user_id, type: Integer

    belongs_to :request, class_name: "Scriba::Request"

    def self.log(severity, time, progname, message)
      collection.insert(request_id: Thread.current[:scriba_request_id],
                        severity: severity,
                        created_at: time,
                        message: message,
                        user_id:  Thread.current[:scriba_user_id]) unless Thread.current[:in_scriba]
    end


    delegate :user, :user_path, to: :request
  end
end
