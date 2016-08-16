class CommentsController < ApplicationController
  respond_to :js
  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]

  def index
    @topic = Topic.includes(:posts).find_by(id: params[:topic_id])
    @post = Post.find_by(id: params[:post_id])
    @comments = @post.comments.order(id: :ASC)
    @comment = Comment.new
  end

  # def new
  #   @topic = Topic.find_by(id: params[:topic_id])
  #   @post = Post.find_by(id: params[:post_id])
  # end

  def create
    @topic = Topic.find_by(id: params[:topic_id])
    @post = Post.find_by(id: params[:post_id])
    @comment = current_user.comments.build(comment_params.merge(post_id: params[:post_id]))
    @new_comment = Comment.new

    if @comment.save
      CommentBroadcastJob.set(wait: 0.1.seconds).perform_later("create", @comment)
      flash.now[:success] = "Comment created"
    else
      flash.now[:danger] = @comment.errors.full_messages
    end
  end

  def edit
    @comment=Comment.find_by(id: params[:id])
    @post = Post.find_by(id: params[:post_id])
    @topic = Topic.find_by(id: params[:topic_id])
    authorize @comment
  end

  def update
    @topic = Topic.find_by(id: params[:topic_id])
    @post = Post.find_by(id: params[:post_id])
    @comment = Comment.find_by(id: params[:id])

    if @comment.update(comment_params)
      flash.now[:success] ="You've created a comment"
      # redirect_to topic_post_comments_path(@topic, @post)
    else
      flash.now[:danger] ="You've created a Dinesh"
      # redirect_to edit_topic_post_comment_path(@topic, @post)
    end

  end

  def destroy
    @topic = Topic.find_by(id: params[:topic_id])
    @post = Post.find_by(id: params[:post_id])
    @comment = Comment.find_by(id: params[:id])
    authorize @comment

    if @comment.destroy
      flash.now[:success] = "Delete batang hidung mu!"
      # redirect_to topic_post_comments_path(@topic, @post)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :image)
  end

end
