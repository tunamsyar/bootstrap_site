class CommentsController <ApplicationController
before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]
  def index
    @topic = Topic.includes(:posts).find_by(id: params[:topic_id])
    @posts = Post.find_by(id: params[:post_id])
    @comments = @posts.comments.order(id: :DESC)
  end

  def new
    @topic = Topic.find_by(id: params[:topic_id])
    @post = Post.find_by(id: params[:post_id])
    @comment = Comment.new
  end

  def create
    @topic = Topic.find_by(id: params[:topic_id])
    @post = Post.find_by(id: params[:post_id])
    @comment = Comment.new(comment_params.merge(post_id: params[:post_id]))

    if @comment.save
      flash[:success] ="You've created a comment"
      redirect_to topic_post_comments_path(@topic, @post)
    else
      flash[:danger] = @comment.errors.full_messages
      redirect_to new_topic_post_comment_path(@topic ,@post)
    end
  end

  def edit
    @comment=Comment.find_by(id: params[:id])
    @post = Post.find_by(id: params[:post_id])
    @topic = Topic.find_by(id: params[:topic_id])
  end

  def update
    @topic = Topic.find_by(id: params[:topic_id])
    @post = Post.find_by(id: params[:post_id])
    @comment = Comment.find_by(id: params[:id])

    if @comment.update(comment_params)
      redirect_to topic_post_comments_path(@topic, @post)
    else
      redirect_to edit_topic_post_comment_path(@topic, @post)
    end

  end

  def destroy
    @topic = Topic.find_by(id: params[:topic_id])
    @post = Post.find_by(id: params[:post_id])
    @comment = Comment.find_by(id: params[:id])

    if @comment.destroy
      redirect_to topic_post_comments_path(@topic, @post)
    end
  end

private

def comment_params
  params.require(:comment).permit(:body, :image)
end

end
