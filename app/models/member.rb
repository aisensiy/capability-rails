class Member
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum
  include ActiveModel::SecurePassword

  enum :role, [:employee, :admin, :system]

  field :name, type: String
  field :password_digest

  embeds_many :certificates
  embeds_many :exam_requests

  validates_presence_of :name, :password, :role

  has_secure_password
end
