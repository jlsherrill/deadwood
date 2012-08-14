require 'ruby-debug'
module Deadwood
  module Katello
    class ActivationKey < Base
      def collection_path(prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        query_options.merge!(self.attributes)
        attributes.delete(:environment_id)
        "#{self.class.prefix(prefix_options)}#{self.class.collection_name}#{query_string(query_options)}"
      end
    end
  end
end
