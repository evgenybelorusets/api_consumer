module UsersHelper
  def destroy_user_link(user)
    if can? :destroy, user
      link_to 'Delete user', user_path(user.uid), class: 'btn btn-danger', method: :delete
    end
  end

  def edit_user_link(user)
    if can? :update, user
      link_to 'Edit user', edit_user_path(user.uid), class: 'btn btn-warning'
    end
  end
end