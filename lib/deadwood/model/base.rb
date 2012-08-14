#
#   Copyright 2011 Red Hat, Inc.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
require 'ruby-debug'
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
