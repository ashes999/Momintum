class Follow < ActiveRecord::Base
    
  belongs_to :user, :class_name => 'User', :foreign_key => 'follower_id'
  belongs_to :target, :class_name => 'User', :foreign_key => 'target_id'
  
end
