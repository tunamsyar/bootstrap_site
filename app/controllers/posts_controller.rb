class PostsController < ApplicationController
  respond_to :js
  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]
  def index
    @topic = Topic.includes(:posts).friendly.find(params[:topic_id])
    @posts = @topic.posts.order(id: :ASC)
    @post = Post.new
  end

  def create
    @topic = Topic.friendly.find(params[:topic_id])
    @post = current_user.posts.build(post_params.merge(topic_id: params[:topic_id]))
    @new_post = Post.new

    if @post.save
      flash[:success] = "You've created a new post."
    else
      flash[:danger] = @post.errors.full_messages
    end
  end

  def edit
    @post = Post.friendly.find(params[:id])
    @topic = @post.topic
    authorize @post
  end

  def update
    @topic = Topic.friendly.find(params[:topic_id])
    @post = Post.friendly.find(params[:id])

    if @post.update(post_params)
      flash.now[:success] = "Post updated"
      # redirect_to topic_posts_path(@topic)
    else
      flash.now[:danger] = "You created a Dinesh"
      # redirect_to edit_topic_post_path(@topic, @post)
    end
  end

  def destroy
    @post = Post.friendly.find(params[:id])
    @topic = @post.topic
    authorize @post

    if @post.destroy
      flash.now[:success] = "Post suda tada"
      # redirect_to topic_posts_path(@topic)
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image)
  end
end
