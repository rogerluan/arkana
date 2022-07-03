# frozen_string_literal: true

require "logger"
require "colorize"

# Contains utilities related to display information to the user on the Terminal (the user's interface).
module UI
  # Logs the message in red color and raise an error with the given message.
  def self.crash(message)
    logger.fatal(message.red)
    raise message
  end

  # Logs the message in cyan color.
  def self.debug(message)
    logger.debug(message.cyan)
  end

  # Logs the message in green color.
  def self.success(message)
    logger.info(message.green)
  end

  # Logs the message in yellow color.
  def self.warn(message)
    logger.warn(message.yellow)
  end

  # Logger used to log all the messages.
  def self.logger
    @logger ||= Logger.new($stdout)
  end
end
