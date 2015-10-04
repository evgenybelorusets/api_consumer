class Comment < BaseResource
  self.site = "#{self.site}/posts/:post_id"

  schema do
    integer :id
    integer :post_id
    integer :user_id
    string  :content
    string  :first_name
    string  :last_name
    string  :email
  end

  def post
    @post ||= Post.find(prefix_options[:post_id])
  end

  def post=(post)
    @post = post
    self.prefix_options[:post_id] = post.id
  end
end
