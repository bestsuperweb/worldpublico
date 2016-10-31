class MicropostsController < ApplicationController
  # before_action :logged_in_user, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Post created successfully!"
    else
      flash[:error] = "Sorry! some errors."
    end
    redirect_to user_path(current_user)
  end

  def destroy
    @micropost = Micropost.find(params[:id])
    @micropost.destroy
    redirect_to user_path(current_user)
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content)
  end
end
