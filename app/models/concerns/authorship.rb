module Concerns
  module Authorship
    FULL_NAME_TEMPLATE = '%{first_name} %{last_name} <%{email}>'

    def author_full_name_with_email
      FULL_NAME_TEMPLATE % { first_name: first_name, last_name: last_name, email: email }
    end
  end
end