class Post < BaseResource
  schema do
    integer :id
    integer :user_id
    string  :title
    string  :content
    string  :first_name
    string  :last_name
    string  :email
  end

  def comments(scope = :all)
    Comment.find(scope, params: { post_id: id })
  end

  def new_comment(attributes)
    Comment.new(attributes).tap { |comment| comment.post = self }
  end

  def comment(id)
    comments(id).tap { |comment| comment.post = self }
  end
end
