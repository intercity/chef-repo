module Rails
  module Helpers

    # Convert Chef-specific collections into generic versions (arrays and hashes)
    # This avoids incorrect type tagging in the YAML file, which would result
    # in issues marshalling the file.
    #
    # For example: `key: !ruby/hash:Chef::Node::ImmutableMash`
    def convert_mash(mash)

      hash = Hash.new

      mash.each do |key, value|
        hash[key.to_s] = convert_value(value)
      end

      hash
    end

    def convert_value(value)
      if value.is_a?(Mash) 
        convert_mash(value)
      elsif value.is_a?(Array)
        value.map { |e| convert_value e }
      else
        value
      end
    end

  end
end

Chef::Recipe.send(:include, ::Rails::Helpers)
Chef::Resource.send(:include, ::Rails::Helpers)
Chef::Provider.send(:include, ::Rails::Helpers)