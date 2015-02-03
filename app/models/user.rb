class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
   # extras
   :confirmable, :timeoutable
   
  # always save emails as lower-case in the DB
  before_save { self.email = email.downcase }

  has_many :sparks, :foreign_key => 'owner_id'

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
end
