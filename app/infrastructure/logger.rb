# typed: true
require 'logger'

module Infrastructure
  class Logger
    def self.logger
      @logger ||= begin
        logger = ::Logger.new($stdout)
        logger.level = ::Logger::INFO
        logger.formatter = proc do |severity, datetime, progname, msg|
          "#{datetime.strftime('%Y-%m-%d %H:%M:%S')} [#{severity}] #{msg}\n"
        end
        logger
      end
    end
  end
end 