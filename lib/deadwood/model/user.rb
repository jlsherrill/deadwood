module Deadwood
  module Katello
    class User < Base
      def collection_path(prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        query_options.merge!(self.attributes)
        self.attributes.clear
        "#{self.class.prefix(prefix_options)}#{self.class.collection_name}#{query_string(query_options)}"
      end

      def encode(options={})
        self.attributes.empty? ? nil : send("to_#{self.class.format.extension}", options)
      end
    end
  end
end
