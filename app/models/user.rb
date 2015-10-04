class User < ActiveRecord::Base
  EXTERNAL_USER_KEY_TEMPLATE = 'external_user_%{id}'
  EXTERNAL_FIELDS = [ :uid, :email ]
  ROLES = {
    admin: 'admin',
    user: 'user',
    guest: 'guest'
  }
  ROLE_VALUES = ROLES.values
  GUEST_UID = '_GUEST_UID_'

  devise :database_authenticatable, :registerable, :recoverable, :validatable

  before_create :generate_uid_and_create_external_user
  before_save :save_external, unless: :new_record?
  before_destroy :destroy_external
  after_commit :reload_external_user

  attr_readonly :uid
  attr_writer :external_user

  delegate :first_name, :last_name, :role, :first_name=, :last_name=, :role=, to: :external_user
  delegate :id, to: :external_user, prefix: true

  paginates_per 10


  class << self
    def guest
      User.new uid: GUEST_UID, role: ROLES[:guest]
    end
  end

  ROLE_VALUES.each do |role|
    define_method("#{role}?") do
      self.role == role
    end
  end

  EXTERNAL_FIELDS.each do |field|
    method_name = "#{field}="

    define_method(method_name) do |value|
      external_user.public_send(method_name, value)
      self[field] = value
    end
  end

  private

  def save_external
    external_user.save!
  end

  def destroy_external
    external_user.destroy
  end

  def reload_external_user
    external_user(true)
  end

  def external_user_key
    EXTERNAL_USER_KEY_TEMPLATE % { id: id }
  end

  def external_user(force = false)
    Rails.cache.delete(external_user_key) if force
    @external_user ||= begin
      if new_record?
        ExternalUser.new(role: ROLES[:user])
      else
        Rails.cache.fetch(external_user_key) do
          ExternalUser.find_by_uid(uid)
        end
      end
    end
  end

  def generate_uid_and_create_external_user
    begin
      self.uid = SecureRandom.hex(16)
    end while self.class.where(uid: uid).exists?
    save_external
  end
end
