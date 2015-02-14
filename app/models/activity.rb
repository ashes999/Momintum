if Rails.application.config.feature_map.enabled?(:activity) 
  
  class Activity < ActiveRecord::Base
    
    @@keys = {
      'created_spark' => '{0} created the spark {1}',
      'updated_spark' => '{0} updated the spark {1}'
    }
    
    # validation fails if these values are symbols, but passes when they're strings
    # that's odd, because you set them on the model as symbols, not strings.
    @@types = ['user', 'spark']
    
    validates_presence_of :key, :source_id, :source_type, :target_id, :target_type
    validates :key, inclusion: { in: @@keys }
    validates :source_type, inclusion: { in: @@types }
    validates :target_type, inclusion: { in: @@types }

    def source_object
      return get_item(source_id, source_type)
    end
    
    def target_object
      return get_item(target_id, target_type)
    end
    
    def message
      return @@keys[self.key]
    end
    
    private
    
    def get_item(id, type)
      raise "Unknown type #{type}" unless @@types.include?(type)
      case type
      when 'user'
        return User.find(id)
      when 'spark'
        return Spark.find(id)
      end
    end
  end
end