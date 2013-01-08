require 'net/http/post/multipart'
require 'oauth2'
require 'httparty'
require 'givey_ruby/version'
require 'givey_ruby/configuration'
require 'givey_ruby/shared'
require 'givey_ruby/controller'
require 'givey_ruby/model'

module GiveyRuby

  def self.configuration
    @configuration ||= GiveyRuby::Configuration.new
  end

  # Yields the global configuration to a block.
  # @yield [Configuration] global configuration
  #
  # @example
  #     GiveySdk.configure do |config|
  #       config.client 'documentation'
  #     end
  def self.configure
    yield configuration if block_given?
  end

end
