require 'sidekiq-scheduler'

# Service that trims log to keep file from getting too big
class KeepLast10LinesJob
  include Sidekiq::Worker

  def perform
    LogManager.keep_last_10_lines
  end

end