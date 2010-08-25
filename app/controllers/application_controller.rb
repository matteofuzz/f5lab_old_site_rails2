# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :set_locale 
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '307b8a34c931d02b46ef87ce7449305c'

  def set_locale 
    if params[:locale] and I18n.available_locales.include? params[:locale].to_sym
      I18n.locale = params[:locale]
    else
      I18n.locale = nil # then I18n.default_locale will be used
    end
  end 
  
  def default_url_options(options={})
   logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end
  
  

  private

  def authorize
    if User.find_by_id(session[:user_id])
      @user = User.find_by_id(session[:user_id]).name
    else
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please log in"
      redirect_to(:controller => "login", :action => "login")
    end
  end

  def load_pages_of_menu
    locale = I18n.locale ? I18n.locale : I18n.default_locale
    @pages_of_menu = Page.find_all_by_locale(locale.to_s, :select => "title, title_locale", :order => "id DESC")
  end

end
