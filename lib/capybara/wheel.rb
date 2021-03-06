Dir.glob(File.join(File.dirname(__FILE__), 'wheel', '*.rb')).each {|file| require file}
require 'capybara'
require 'capybara/dsl'
require 'rspec'

module Capybara
  module Wheel
    # main mixin to access wheel

    def self.included(base)
      base.instance_eval do
        alias :background :before
        alias :scenario :it
        alias :given :let
        alias :given! :let!
      end
    end

    module FeatureOverride
      def feature(*args, &block)
        options = {
          type: :wheel_feature,
          caller: caller
        }
        options.merge!(args.pop) if args.last.is_a?(Hash)
        describe(*args, options, &block)
      end
    end

  end
end

extend Capybara::Wheel::FeatureOverride
RSpec.configuration.include Capybara::Wheel, wheel_feature: true
