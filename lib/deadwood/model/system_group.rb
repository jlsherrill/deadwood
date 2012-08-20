module Deadwood
  module Katello
    class SystemGroup < Base
      def collection_path(prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        query_options.merge!(self.attributes)
        org_id = self.organization_id
        self.attributes().delete(:organization_id)
        "#{self.class.prefix(prefix_options)}organizations/#{org_id}/#{self.class.collection_name}#{query_string(query_options)}"
      end

      def element_path(id = self.id, prefix_options = {}, query_options = nil)
          prefix_options, query_options = split_options(prefix_options) if query_options.nil?
          org_id = self.organization_id
          # Remove the attributes that aren't allowed to be updated
          attributes.delete(:organization_id)
          "#{self.class.prefix(prefix_options)}organizations/#{org_id}/#{self.class.collection_name}/#{self.id}#{query_string(query_options)}"
      end
    end
  end
end
