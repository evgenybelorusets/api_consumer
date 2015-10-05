module PostsHelper
  def destroy_post_link(post)
    if can? :destroy, post
      link_to t('post.button.destroy'),
        post_path(post),
        class: 'btn btn-danger',
        method: :delete,
        data: { confirm: t('common.delete_confirmation'), confirm_title: t('common.delete') }
    end
  end

  def edit_post_link(post)
    if can? :update, post
      link_to t('post.button.edit'), edit_post_path(post), class: 'btn btn-warning'
    end
  end

  def post_link(post, text = t('post.button.show'))
    if can? :read, post
      link_to text, post_path(post), class: 'btn btn-info'
    end
  end
end