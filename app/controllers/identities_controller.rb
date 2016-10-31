class IdentitiesController < ApplicationController
  # before_action :logged_in_user, only: [:create, :destroy]
  skip_before_filter :verify_authenticity_token, :only => [:update]

  def create
    @identity = current_user.identities.build(identity_params)
    if @identity.save
      flash[:success] = "Post created successfully!"
    else
      flash[:error] = "Sorry! some errors."
    end
    redirect_to user_path(current_user)
  end

  def update
   @identity = Identity.find(params[:id])
   @identity.update(identity_params)
   redirect_to user_path(current_user)
  end

  def destroy
    @identity = Identity.find(params[:id])
    @identity.destroy
    redirect_to user_path(current_user)
  end

  private

  def identity_params
    params.require(:identity).permit([:provider, :url])
  end
end