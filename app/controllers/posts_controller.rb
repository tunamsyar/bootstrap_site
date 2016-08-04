class PostsController < ApplicationController

  def index
@posts = Post.all.order(id: :DESC)
  end

  def show
    @posts = Post.find_by(id: params[:id])
  end

  def new
    @posts = Post.new
  end

def create
  @posts = Post.new(post_params)

  if @posts.save
    redirect_to posts_path
  else
    render new_post_path
  end
end

def edit
  @posts = Post.find_by(id: params[:id])
end

def update
   @posts = Post.find_by(id: params[:id])
   if @posts.update(post_params)
     redirect_to post_path(@posts)
   else
     redirect_to edit_post_path(@posts)
   end
end

def destroy
  @posts = Post.find_by(id: params[:id])
  if @posts.destroy
    redirect_to posts_path
  else
    redirect_to post_path(@posts)
  end
end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

end
