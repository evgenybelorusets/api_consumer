class User < ActiveRecord::Base
  EXTERNAL_USER_KEY_TEMPLATE = 'external_user_%{id}'
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

  scope :guest, ->{ where(role: ROLES[:guest]) }

  def guest?
    self.role == ROLES[:guest]
  end

  def user?
    self.role == ROLES[:user]
  end

  def admin?
    self.role == ROLES[:admin]
  end

  def uid
    guest? ? GUEST_UID : self[:uid]
  end

  def uid=(value)
    external_user.uid = value
    self[:uid] = value
  end

  def email=(value)
    external_user.email = value
    self[:email] = value
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
