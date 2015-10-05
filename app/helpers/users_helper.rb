module UsersHelper
  def destroy_user_link(user)
    if can? :destroy, user
      link_to t('user.button.destroy'),
        user_path(user.uid),
        class: 'btn btn-danger',
        method: :delete,
        data: { confirm: t('common.delete_confirmation'), confirm_title: t('common.delete') }
    end
  end

  def edit_user_link(user)
    if can? :update, user
      link_to t('user.button.edit'), edit_user_path(user.uid), class: 'btn btn-warning'
    end
  end
end