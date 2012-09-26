module Scriba
  class Request
    include Mongoid::Document
    field :env, type: Hash
    field :response_status, type: Integer
    field :response_headers, type: Hash
    field :response_body, type: String
    field :user_id, type: String
    has_many :entries, class_name: "Scriba::Entry"

    def self.log(env)
      Thread.current[:scriba_request_id] = nil
      Thread.current[:scriba_user_id] = nil

      request = new(env: prepare_hash(env))

      Thread.current[:in_scriba] = !!(request.env["PATH_INFO"] =~ /scriba/)

      request.save unless Thread.current[:in_scriba]

      Thread.current[:scriba_request_id] = request.id
      Thread.current[:scriba_user_id] = request.user.try(:id)

      resp = yield env
      request.update_attributes response_status: resp[0],
                                response_headers: resp[1],
                                response_body: if resp[2].respond_to?(:body) && resp[2].body.try(:encoding).try(:name) == "UTF-8"
                                                 resp[2].body if Scriba.log_response_body
                                               else
                                                 # resp[2].to_s
                                               end,
                                user_id: request.user.try(:id)
      resp
    end

    def self.prepare_hash(hash)
      unless hash.kind_of?(Hash)
        begin
          BSON::serialize(hash)
          return hash
        rescue
          return hash.to_s
        end
      end

      return Hash[
        hash.select {
          |k,v|
          v.kind_of?(String) || v.kind_of?(Numeric) ||
          v.kind_of?(TrueClass) || v.kind_of?(FalseClass) ||
          v.kind_of?(Hash)
        }.map {|k,v| [k.to_s.gsub(".", "_dot_"), prepare_hash(v)] }
      ]
    end

    def path
      env["PATH_INFO"]
    end

    def user
      if Scriba.user_finder.respond_to?(:call)
        Scriba.user_finder.call(env)
      else
        nil
      end
    end

    def user_path
      if Scriba.user_path_finder.respond_to?(:call)
        Scriba.user_path_finder.call(user)
      else
        ""
      end
    end
  end
end

