module Deadwood
  module Katello
    class Role < Base
      def collection_path(prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        query_options.merge!(self.attributes)
        if self.attributes.include?(:user_id)
          user_id = self.user_id
          self.attributes.delete(:user_id)
          "#{self.class.prefix(prefix_options)}users/#{user_id}/#{self.class.collection_name}#{query_string(query_options)}"
        else
          "#{self.class.prefix(prefix_options)}#{self.class.collection_name}#{query_string(query_options)}"
        end
      end

      def element_path(id = self.id, prefix_options = {}, query_options = nil)
          prefix_options, query_options = split_options(prefix_options) if query_options.nil?
          # Remove the attributes that aren't allowed to be updated
          attributes.delete(:updated_at)
          attributes.delete(:created_at)
          attributes.delete(:locked)
          "#{self.class.prefix(prefix_options)}#{self.class.collection_name}/#{self.id}#{query_string(query_options)}"
      end
    end
  end
end
