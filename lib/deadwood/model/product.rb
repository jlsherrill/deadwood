module Deadwood
  module Katello
    class Product < Base
      def collection_path(prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        query_options.merge!(self.attributes)
        provider_id = self.provider_id
        attributes.delete(:provider_id)
        "#{self.class.prefix(prefix_options)}providers/#{provider_id}/product_create#{query_string(query_options)}"
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
