class RepliesController < ApplicationController

  def create
    @reply = current_user.replies.build(reply_params)
    if @reply.save
      flash[:success] = "Reply created successfully!"
    else
      flash[:error] = "Sorry! some errors."
    end
    redirect_to user_path(current_user)
  end

  def destroy
  end

  private

  def reply_params
    params.require(:reply).permit(:content, :micropost_id )
  end

end
