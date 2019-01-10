class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.limit(10).includes(:photos, :user).order('created_at DESC')
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
    @post = Post.find_by(id: params[:id])
    @photos = @post.photos
  end

  private
    def post_params
      params.require(:post).permit(:caption).merge(user_id: current_user.id)
    end
end
