#  Copyright (c) 2012 Chris Alfonso
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.
module Deadwood
  module Katello
    class Base < ActiveResource::Base
      self.format = :json
      self.ssl_options = {:verify_mode  => OpenSSL::SSL::VERIFY_NONE}

      class << self
        def element_path(id, prefix_options = {}, query_options = nil)
          prefix_options, query_options = split_options(prefix_options) if query_options.nil?
          "#{prefix(prefix_options)}#{collection_name}/#{id}#{query_string(query_options)}"
        end

        def collection_path(prefix_options = {}, query_options = nil)
          prefix_options, query_options = split_options(prefix_options) if query_options.nil?
          "#{prefix(prefix_options)}#{collection_name}#{query_string(query_options)}"
        end

        def instantiate_collection(collection, prefix_options = {})
          if collection.kind_of? Array
            collection.collect! { |record| instantiate_record(record, prefix_options) }
          elsif collection.kind_of? String
            collection
          else
            [instantiate_record(collection, prefix_options)]
          end
          rescue ArgumentError
        end

        def get(method_name, options = {})
          object_array = connection.get(custom_method_collection_url(method_name, options), headers)
          if object_array.class.to_s=="Array"
            object_array.collect! {|record| self.class.new.load(record)}
          else
            self.class.new.load(object_array)
          end
        end

        def config
          @@config
        end

        def config=(conf={})
          @@config = conf
          self.site = @@config[:site]
        end

        def use_oauth?
          config[:consumer_key] && config[:consumer_secret] && config[:site]
        end
      end

      def load_attributes_from_response(response)
        if response['Content-Length'] != "0" && response.body.strip.size > 0
          load(self.class.format.decode(response.body))
        end
        rescue ArgumentError
      end

      def collection_path(prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        query_options.merge!(self.attributes)
        "#{self.class.prefix(prefix_options)}#{self.class.collection_name}#{query_string(query_options)}"
      end

      def query_string(options)
        "?#{options.to_query}" unless options.nil? || options.empty?
      end
    end
  end
end
