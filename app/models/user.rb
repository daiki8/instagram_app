class User < ApplicationRecord
	before_save :downcase_email
	has_many :microposts, dependent: :destroy
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\Z/i
	validates :email, presence: true, length: { maximum: 255}, 
	                format: { with: VALID_EMAIL_REGEX},
	                uniqueness: {case_sensitive: false}
	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true  # allow_nil:error-messageのダブりを防ぐため


	private
  
    def downcase_email
      email.downcase!
    end
end
