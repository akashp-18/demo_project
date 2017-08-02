class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :role
  has_many :items
  validates_presence_of :name
	before_save :assign_role
	after_create :send_admin_mail  

	def assign_role
	  self.role = Role.find_by name: "Regular" if self.role.nil?
	end

	def admin?
  self.role.name == "Admin"
	end

	def superadmin?
  self.role.name == "Superadmin"
	end

	def regular?
  self.role.name == "Regular"
	end

	def active_for_authentication? 
    super && approved? 
  end 
  
  def inactive_message 
    if !approved? 
      :not_approved 
    else 
      super # Use whatever other message 
    end 
  end
  
  def send_admin_mail
  	UserMailer.send_welcome_email(self).deliver_later
  end
  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end
end
