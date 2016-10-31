class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :finish_signup]

    # GET /users/:id.:format
  def show
    #authorize! :read, @user
    @microposts = @user.microposts.paginate(page: params[:page], per_page: 5 )
    @micropost = current_user.microposts.build if user_signed_in?
    @reply = current_user.replies.build if user_signed_in?
  end

  # GET /users/:id/edit
  def edit
    # authorize! :update, @user
    @microposts = @user.microposts.paginate(page: params[:page], per_page: 5 )
    @micropost = current_user.microposts.build if user_signed_in?
    @reply = current_user.replies.build if user_signed_in?
    @identity = current_user.identities.build if user_signed_in?
  end

  # PATCH/PUT /users/:id.:format
  def update
    # authorize! :update, @user
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        format.html { redirect_to @user, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user 
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)
        #@user.skip_reconfirmation!
        sign_in(@user, :bypass => true)
        redirect_to @user, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

  # DELETE /users/:id.:format
  def destroy
    # authorize! :delete, @user
    @user.destroy
    redirect_to root_url
  end
  
  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      accessible = [ :name, :email, :address, :tel, :website, :about, :mission, :avatar, :category ] # extend with your own params
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end