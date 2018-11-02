class User < ApplicationRecord
	attr_accessor :remember_token
	before_save :downcase_email
	has_many :posts, dependent: :destroy
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\Z/i
	validates :email, presence: true, length: { maximum: 255}, 
	                format: { with: VALID_EMAIL_REGEX},
	                uniqueness: {case_sensitive: false}
	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true  # allow_nil:error-messageのダブりを防ぐため

	# ランダムなトークンを返す
	def User.new_token
    SecureRandom.urlsafe_base64
	end
	
	# 永続的セッションで使用するユーザーをデータベースに記憶する
	def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
	end

	# ユーザーログインを破棄する
	def forget
		update_attribute(:remember_digest, nil)
	end
	
	# 渡されたトークンがダイジェストと一致したらtrueを返す
	def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

	private
  
    def downcase_email
      email.downcase!
    end
end
