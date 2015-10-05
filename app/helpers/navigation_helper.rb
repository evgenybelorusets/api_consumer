module NavigationHelper
  def nav_posts_link
    if can? :read, Post
      content_tag :li, link_to(t('post.button.index'), posts_path, class: 'btn nav-btn')
    end
  end

  def nav_my_posts_link
    if signed_in?
      content_tag :li, link_to(t('post.button.my'), posts_path(user_id: current_user.external_user_id), class: 'btn nav-btn')
    end
  end

  def nav_new_post_link
    if can? :create, Post
      content_tag :li, link_to(t('post.button.new'), new_post_path, class: 'btn nav-btn')
    end
  end

  def nav_users_link
    if can? :read, User
      content_tag :li, link_to(t('user.button.index'), users_path, class: 'btn nav-btn')
    end
  end

  def nav_profile_link
    if signed_in?
      content_tag :li, link_to(t('user.button.show'), edit_user_registration_path, class: 'btn nav-btn')
    end
  end

  def nav_sign_in_or_out_link
    content_tag :li do
      if signed_in?
        link_to t('login.sign_out'), destroy_user_session_path, class: 'btn nav-btn', method: :delete
      else
        link_to t('login.sign_in'), user_session_path, class: 'btn nav-btn'
      end
    end
  end
end