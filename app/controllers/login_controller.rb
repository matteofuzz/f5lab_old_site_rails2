class LoginController < ApplicationController
  
  layout "admin"
  
  before_filter :authorize, :except => :login

  def add_user
    @user = User.new(params[:user])
    if request.post? and @user.save
      flash.now[:notice] = "User #{@user.name} created"
      @user = User.new
      redirect_to(:controller => "login", :action => "index")
    end
  end

  def login
    session[:user_id] = nil
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:user_id] = user.id
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(:controller => "pages", :action => "index")
      else
        flash[:notice] = "Invalid user/password combination"
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to(:controller => "site", :action => "go")
  end

  def index
    @users = User.find(:all)
  end

  def delete_user
    username = User.find_by_id(params[:id]).name
    User.delete(params[:id])
    flash[:notice] = "User #{username} deleted."
    redirect_to(:controller => "login", :action => "index")
  end

	def edit_password
	end
	
	def change_password
	end
	
  # TODO a rename user method
  
end
