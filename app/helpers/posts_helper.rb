module PostsHelper
  def destroy_post_link(post)
    if can? :destroy, post
      link_to 'Delete post', post_path(post), class: 'btn btn-danger', method: :delete
    end
  end

  def edit_post_link(post)
    if can? :update, post
      link_to 'Edit post', edit_post_path(post), class: 'btn btn-warning'
    end
  end

  def post_link(post, text = 'View post')
    if can? :read, post
      link_to text, post_path(post), class: 'btn btn-info'
    end
  end
end