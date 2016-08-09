class UserController

  def new
    @user = User.new
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def create
    @user = User.find_by(id: params[:id])
      if @user.save
        redirect_to users_path
      else
        redirect_to new_user_path
      end
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)
      redirect_to users_path
    else
      redirect_to edit_user_path
  end

private

  def user_params
    params.require(:user).permit(:email, :password, :username, :image)
  end

end
