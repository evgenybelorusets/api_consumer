class PostsController < ApplicationController
  skip_before_action :authenticate_user!, except: [ :create, :update, :destroy ]
  authorize_resource :post

  def update
    if post.update_attributes(post_params)
      redirect_to post_url(post)
    else
      render :edit
    end
  end

  def create
    if post.save
      redirect_to post_url(post)
    else
      render :new
    end
  end

  def destroy
    post.destroy
    render :index
  end

  protected

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def post
    @post ||= params[:id] ?
      Post.find(params[:id]) :
      Post.new(post_params)
  end
  helper_method :post

  def posts
    @posts ||= KaminariResourceCollection.new Post.find(:all, params: params)
  end
  helper_method :posts
end