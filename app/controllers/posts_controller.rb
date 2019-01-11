class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i(show destroy)

  def index
    @posts = Post.limit(10).includes(:photos, :user, :likes).order('created_at DESC')
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if params[:images]
      params[:images].each do |img|
        @post.save
        @post.photos.create(image: img)
        redirect_to root_path
        flash[:notice] = "Saved"
      end
    else
      redirect_to root_path
      flash[:alert] = "Fail"
    end
  end

  def show
    #@post = Post.find_by(id: params[:id])
    @photos = @post.photos
  end
  #@post = Post.find_by(id: params[:id])
  def destroy
    if @post.user == current_user
      flash[:notice] = "Deleted" if @post.destroy
    else
      flash[:alert] = "Delete fail"
    end
      redirect_to root_path
  end

  private
    def post_params
      params.require(:post).permit(:caption).merge(user_id: current_user.id)
    end

    def set_post
      @post = Post.find_by(id: params[:id])
    end

end
