class CommentsController < ApplicationController
  layout false

  skip_before_action :authenticate_user!, except: [ :create, :update, :destroy ]

  authorize_resource :comment

  rescue_from CanCan::AccessDenied do |exception|
    log_exception(exception)
    head :forbidden
  end

  def update
    if comment.update_attributes(comment_params)
      render :show
    else
      head :unprocessable_entity
    end
  end

  def destroy
    comment.destroy
    head :no_content
  end

  def create
    if comment.save
      render :show
    else
      head :unprocessable_entity
    end
  end

  protected

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end

  def comment
    @comments ||= params[:id] ? post.comment(params[:id]) : post.new_comment(comment_params)
  end
  helper_method :comment

  def comments
    @comments ||= post.comments
  end
  helper_method :comments

  def post
    @post ||= Post.find(params[:post_id])
  end
  helper_method :post
end