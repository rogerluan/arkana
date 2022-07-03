# frozen_string_literal: true

require "dotenv"

# This helper is a mere utility used to facilitate and orchestrate the loading of multiple Dotenv files.
module DotenvHelper
  # Loads the appropriate dotenv file(s).
  def self.load(config)
    Dotenv.load(config.dotenv_filepath) if config.dotenv_filepath
    # Must be loaded after loading the `config.dotenv_filepath` so they override each other in the right order
    Dotenv.load(flavor_dotenv_filepath(config)) if config.current_flavor
  end

  def self.flavor_dotenv_filepath(config)
    dotenv_dirname = File.dirname(config.dotenv_filepath)
    flavor_dotenv_filename = ".env.#{config.current_flavor.downcase}"
    File.join(dotenv_dirname, flavor_dotenv_filename)
  end
end
