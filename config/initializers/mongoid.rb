# module Mongoid
#  module Document
#    def as_json(options={})
#      attrs = super(options)
#      attrs["id"] = attrs["_id"].to_s
#      attrs
#    end
#  end
# end

Mongoid::Document.send(:include, ActiveModel::SerializerSupport)
Mongoid::Criteria.delegate(:active_model_serializer, to: :to_a)
Mongoid.raise_not_found_error = false

#Mongoid::Serializer.configure!

ActiveModel::Serializer.setup do |config|
	config.embed = :ids
	config.embed_in_root = true
end

module BSON
	class ObjectId
		alias :to_json :to_s
		alias :as_json :to_s
	end
end
