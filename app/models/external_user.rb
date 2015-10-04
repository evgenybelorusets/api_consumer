class ExternalUser < BaseResource
  self.element_name = 'user'

  schema do
    integer :id
    string  :first_name
    string  :last_name
    string  :uid
    string  :email
    string  :role
  end

  class << self
    def find_by_uid(uid)
      find(:first, params: { uid: uid })
    end
  end
end
