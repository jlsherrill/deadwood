require 'ruby-debug'
module Deadwood
  module Katello
    class Organization < Base
      def new?
        is_new = id.nil?
        # not allowed to send the id as part of an org on POST or PUT
        attributes.delete(:id)
        return is_new
      end

      def element_path(id, prefix_options = {}, query_options = nil)
        "#{self.class.prefix(prefix_options)}#{self.class.collection_name}/#{self.name}"
      end
    end
  end
end
