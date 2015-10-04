module CommentsHelper
  def destroy_comment_link(comment)
    if can? :destroy, comment
      link_to 'Delete comment',
        post_comment_path(post, comment),
        method: :delete,
        class: 'btn btn-danger delete-comment',
        remote: true
    end
  end

  def edit_comment_link(comment)
    if can? :update, comment
      link_to 'Edit comment', edit_post_comment_path(post, comment), class: 'btn btn-warning edit-comment', remote: true
    end
  end

  def new_comment_link
    if can? :create, Comment
      link_to 'Add comment', new_post_comment_path(post), class: 'btn btn-success new-comment', remote: true
    end
  end
end