class TopicsController < ApplicationController
  respond_to :js
  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]

  def index
    # @topics = Topic.all.order(id: :DESC)
    @topic = Topic.new
    @topics = Topic.page(params[ :page]).per(5).all.order(id: :DESC)
  end

  # def new
  #   @topic = Topic.new
  #   authorize @topic
  # end

  def create
    @topic = current_user.topics.build(topic_params)
    @new_topic = Topic.new
    authorize @topic

    if @topic.save
      flash[:success] = "You've created a new topic."
    else
      flash[:danger] = @topic.errors.full_messages
    end
  end

def edit
  @topic = Topic.friendly.find(params[:id])
  authorize @topic

end

def update
    @topic = Topic.friendly.find(params[:id])
    authorize @topic

    if @topic.update(topic_params)
      flash.now[:success] = "Topic Updated"
      # redirect_to topics_path
    else
      flash.now[:danger] = "You've created a Dinesh"
      # redirect_to edit_topic_path(@topic)
    end
end

def destroy
    @topic = Topic.friendly.find(params[:id])
    authorize @topic

    if @topic.destroy
      flash.now[:success] = "Topic suda delete da.."
    #   redirect_to topics_path
    # else
    #   redirect_to topics_path(@topic)
    end

  end
  private

  def topic_params
    params.require(:topic).permit(:title, :description)
  end

end
