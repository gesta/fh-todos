class User < ApplicationRecord
  VALIDATE_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save { self.email = email.downcase }

  validates :admin?, inclusion: { in: [true, false], message: "%{value} is not true or false" }
  validates :email, presence: true,
            uniqueness: { case_sensitive: false },
            length: { maximum: 256, too_long: 'has to be up to %{count} characters' },
            format: { with: VALIDATE_EMAIL_REGEX, message: "is not in a valid format" }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
