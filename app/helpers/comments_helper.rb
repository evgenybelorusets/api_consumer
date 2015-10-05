module CommentsHelper
  def destroy_comment_link(comment)
    if can? :destroy, comment
      link_to t('comment.button.destroy'),
        post_comment_path(post, comment),
        method: :delete,
        class: 'btn btn-danger delete-comment',
        remote: true,
        data: { confirm: t('common.delete_confirmation'), confirm_title: t('common.delete') }
    end
  end

  def edit_comment_link(comment)
    if can? :update, comment
      link_to t('comment.button.edit'), edit_post_comment_path(post, comment), class: 'btn btn-warning edit-comment', remote: true
    end
  end

  def new_comment_link
    if can? :create, Comment
      link_to t('comment.button.new'), new_post_comment_path(post), class: 'btn btn-success new-comment', remote: true
    end
  end
end