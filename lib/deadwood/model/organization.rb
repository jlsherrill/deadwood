require 'ruby-debug'
module Deadwood
  module Katello
    class Organization < Base
      def new?
        name.nil?
      end
      def element_path(id, prefix_options = {}, query_options = nil)
        "#{self.class.prefix(prefix_options)}#{self.class.collection_name}/#{self.name}"
      end
    end
  end
end
