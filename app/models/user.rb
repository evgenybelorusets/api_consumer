class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :validatable
  before_create :generate_uid

  private

  def generate_uid
    self.uid = SecureRandom.hex(16) while self.class.where(uid: uid).exists?
  end
end
