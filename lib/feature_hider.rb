RAILS_ROOT = File.join(File.dirname(__FILE__), '..', '..', '..', '..') unless defined?(RAILS_ROOT)
RAILS_ENV = 'development' unless defined?(RAILS_ENV)
require 'yaml' unless defined?(YAML)

module Animoto
  module FeatureFinder
    class FeatureNotDefined < StandardError; end
    
    class Feature
      def initialize(name, active)
        @name, @active = name, active
      end
      
      def active?
        @active
      end
    end
    
    class FeatureList
      def initialize
        @list = { }
        file_path = File.join(RAILS_ROOT, 'config', 'features.yml')
        logger.info("=> Feature List not found.") and return unless File.exists?(file_path)
        logger.info "=> Loading feature list for #{RAILS_ENV}"
        YAML.load_file(file_path).each do |key, value|
          name = key.to_sym
          active = value[RAILS_ENV]
          logger.info "   - #{name} (#{active ? 'active' : 'disabled'})"
          @list[name] = Feature.new(name, active)
        end
      end
      
      def [](name)
        @list[name] || begin
          raise FeatureNotDefined.new("No feature named \"#{name}\"")
        end
      end
      
      def logger
        ActiveRecord::Logger.new
        rescue
          require 'logger'
          return Logger.new(File.join(RAILS_ROOT, 'log', "#{RAILS_ENV}.log"))
      end
    end
  end
end

FEATURES = Animoto::FeatureFinder::FeatureList.new