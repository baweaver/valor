require 'valor/version'
require 'json'

module Valor
  class Generator

    # name           - Name of the base class
    # raw_data       - Either JSON or a Ruby Hash
    # save_directory - If specified, will attempt to auto-save generated classes here.
    def initialize(name, raw_data, save_directory = nil)
      @models = {}
      data = raw_data.is_a?(Hash) ? raw_data : JSON.parse(raw_data)
      @models[name] = reduce_hash(data)

      save_files(save_directory) if save_directory
    end

    # Saves classes and attributes to individual file classes
    def save_files(save_directory = Dir.pwd)
      raise "Invalid Directory!" unless File.directory?(save_directory)

      @models.each_pair { |klass_name, attributes|
        file_name = "#{save_directory}/#{klass_name}.rb"

        unless File.exist?(file_name) # Make sure we're not double writing here
          File.open(file_name, 'w') do |file|
            file.puts "class #{klass_name}"
            file.puts '  include Virtus.model'
            file.puts ''
            attributes.each { |attribute| file.puts "  #{attribute}" }
            file.puts 'end'
          end
        end
      }
    end

    private

    def reduce_hash(data)
      data.each_pair.reduce([]) { |data, (key, value)|
        if value.is_a?(Hash)
          name = key.to_s.capitalize
          @models[name] = interpret(value)
          data << "attribute :#{key}, #{name}"
        else
          data << "attribute :#{key}, #{interpret(value)}"
        end
      }
    end

    def reduce_array(data)
      if data.first.is_a?(Hash)
        type = data.first.keys.first.to_s.capitalize
        @models[type] = reduce_hash(data.first)
      else
        type = data.first.class
      end

      "Array[#{type}]"
    end

    def interpret(value)
      case
      when value.is_a?(Hash)
        reduce_hash(value)
      when value.is_a?(Array)
        reduce_array(value)
      when value.is_a?(Fixnum)
        'Integer'
      when value.is_a?(TrueClass) || value.is_a?(FalseClass)
        'Boolean'
      else 
        value.class.to_s
      end
    end
  end
end
