class IndexController < ApplicationController
  def home
  end

  def search
    #@users = User.all
    if params[:search] != ''
       @users = User.where( "name LIKE ? AND category != ?", "%#{params[:search]}%", '0' ).order("name DESC") if params[:org] == "Organization"
       @users = User.where([ "name LIKE ? AND category = ?", "%#{params[:search]}%", '0' ]).order("name DESC") if params[:org] == "Individual"
    else
      @users = User.where( "category != ?", '0' ).order('name ASC') if params[:org] == "Organization"
      @users = User.where("category = ?", '0').order('name ASC') if params[:org] == "Individual"
    end
    @users = @users.paginate(page: params[:page], per_page: 5 ) unless @users.nil?
  end

  def about

  end

  def contact

  end
end


