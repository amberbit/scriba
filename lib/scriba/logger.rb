module Scriba
  class Logger < ActiveSupport::BufferedLogger
    self.silencer = false

    private
    def open_logfile(log)
      FileAndMongoLogger.new log
    end
  end

  class FileAndMongoLogger < ::Logger
    def add(severity, message = nil, progname = nil, &block)
          severity ||= UNKNOWN
    if @logdev.nil? or severity < @level
      return true
    end
    progname ||= @progname
    if message.nil?
      if block_given?
        message = yield
      else
        message = progname
        progname = @progname
      end
    end
    @logdev.write(
      format_message(format_severity(severity), Time.now, progname, message))
      begin
        Scriba::Entry.log(format_severity(severity), Time.now, progname, message)
      rescue Exception => e
        # silently fail when no mongodb logging possible
      end
    true
    end
  end
end
