class UsersController < ApplicationController
  before_filter :require_login
  skip_before_filter :require_login, only: [:index, :new, :create]

  def index
    @users = User.all
    @users = if params[:search]
      User.where("name LIKE ?", "%#{params[:search]}%")
    else
      User.all
    end
    #
     if params[:tag]
       @users = User.tagged_with(params[:tag]) #.order(:created_at).page(page)
     else
       @user = User.all
     end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @user = User.find(params[:id])
    @comment = @user.comments.build

    # if params[:tag]
    #  @users = User.tagged_with(params[:tag]) #.order(:created_at).page(page)
    # else
    #  @user = User.all #order(:created_at).page(page)
    #end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      auto_login(@user)
      redirect_to root_path, :notice => "Welcome to Uncomfort Yourself!" 
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if current_user.update_attributes(user_params)
      redirect_to user_path(@user), :notice => "User Info Updated!"
    else
      render :edit
    end
  end

  def destroy
  end

  private 
  def user_params
    params.require(:user).permit(:name, :image, :bio, :email, :password, :password_confirmation, :tag_list)
  end

  def not_authenticated
    redirect_to login_path, alert: "Please Login First"
  end
end