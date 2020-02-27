# frozen_string_literal: true

require 'envyable'
require 'find'

module Envyable
  # Internal: Automatically run Envyable.load before the Rails application loads
  # it's environment based config.
  class VaultRailtie < Rails::Railtie
    # Internal: sets up the initializer to run when the Railtie is run.
    initializer 'envyable.load', before: :load_environment_config do
      load
    end

    # Internal: loads Envyable using the default config/env.yml location and the
    # current Rails environment.
    def load
      path = "/vault/secrets"
      Find.find(path) { |f| f.include?("yml") && Envyable.load(f, Rails.env) } if File.exists?(path)
    end

    # Avoid Rails calling `Kernel#load` via #method_mising
    def self.load
      instance.load
    end
  end
end
