class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
   # extras
   :confirmable, :timeoutable
   
  # always save emails as lower-case in the DB
  before_save { self.email = email.downcase }

  has_many :sparks, :foreign_key => 'owner_id', :dependent => :nullify

  if Rails.application.config.feature_map.enabled?(:spark_likes)
    has_many :likes
  end
  
  if Rails.application.config.feature_map.enabled?(:follow_users)
    has_many :follows, :foreign_key => 'target_id'
  end

  validates :email,
    :presence => true,
    :uniqueness => {
      :case_sensitive => false
    }

  validates_length_of :email, :in => 6..50
  
  if Rails.application.config.feature_map.enabled?(:username) 
    attr_accessor :login # virtual field: username or email
    
    validates :username,
      :presence => true,
      :uniqueness => {
        :case_sensitive => false
      }
      
    validates_length_of :username, :in => 3..50
  
  
     # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address#overwrite-devises-find_for_database_authentication-method-in-user-model
    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions.to_h).first
      end
    end
  end
  
  # rename to owns?
  def is_owner?(spark)
    return !spark.ownerless? && !spark.owner_id.nil? && self.id == spark.owner.id
  end
  
  # rename to on_team?
  def is_on_team?(spark)
    return false
  end
  
  def can_edit?(spark)
    return !spark.ownerless? && (self.is_owner?(spark) || self.is_on_team?(spark))
  end
  
  # Name shown in the activity 
  # Also a safe name to show in general (eg. email vs. username)
  def activity_name
    if Rails.application.config.feature_map.enabled?(:username)
      return self.username
    else
      return self.email
    end
  end
  
  if Rails.application.config.feature_map.enabled?(:activity)
    def activities
      to_return = Activity.where('(source_type = "user" AND source_id = :id) OR (target_type = "user" AND target_id = :id)', { :id => self.id })
        .order(:created_at => :desc)
      return to_return
    end
  end
end
