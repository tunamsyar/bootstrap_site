class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
      if @user.save
        flash[:success]="New User created"
        redirect_to root_path
      else
        flash[:danger]= "Passwords do not match!"
        redirect_to new_user_path
      end
  end

  def update
    @user = User.friendly.find(params[:id])
    if @user.update(user_params)
      flash[:success]="Account Updated"
      redirect_to root_path
    else
      redirect_to edit_user_path
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :username, :image)
    end

end
