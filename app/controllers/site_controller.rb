class SiteController < ApplicationController
  before_filter :load_pages_of_menu

  def go
    @title = params[:title]
    @locale = I18n.locale ? I18n.locale : I18n.default_locale 
    @page = Page.find_by_title_and_locale(@title, @locale.to_s)
    unless @page
      @title = 'home'
      @page = Page.find_by_title_and_locale(@title, @locale.to_s)
      unless @page
        @page = Page.find_by_title(@title)
      end
    end
    @content = @page.content
    @body_id = '<body id="'+@title+'">'
    if @title == "home"
      if params[:sequence]
        @sequence = params[:sequence]
      else
        if session[:sequence]
          @sequence = session[:sequence]
        else
          @sequence = 'default'
        end
      end
      if params[:slide_frequency]
        @slide_frequency = params[:slide_frequency]
      else
        if session[:slide_frequency]
          @slide_frequency = session[:slide_frequency]
        else
          @slide_frequency = 14.0
        end
      end
      session[:slide_frequency] = @slide_frequency
      @appear_time = [@slide_frequency.to_f*0.3,3.0].min
      @fade_time = [@slide_frequency.to_f*0.3,3.0].min
      @show_time = @slide_frequency.to_f - (0.75*(@appear_time+@fade_time))
      load_slideshow
    end
  end

  def search
    @title = 'search'
    @page = 'search'
    @keyword = params[:keyword]
    @pages = Page.find(:all, :order => "id DESC")
    @posts = Post.find(:all, :order => "created_at DESC")
    @results = []
    @pages.each do |p|
      if p.title=~ /#{@keyword}/i
        @results << [p.title, url_for(:controller => "site", :action => "go", :title => p.title, :locale => p.locale)]
      end
      if p.content =~ /#{@keyword}/i
        regex = /.{0,10}#{@keyword}.{0,10}/i
        p.content.scan(regex).each do |cit|
          citation = "...#{cit}..."
          @results << [citation, url_for(:controller => "site", :action => "go", :title => p.title, :locale => p.locale)]
        end
      end
    end
    @posts.each do |p|
      if p.title=~ /#{@keyword}/i
        @results << [p.title, url_for(:controller => "blog", :action => "show", :id => p.id)]
      end
      if p.content =~ /#{@keyword}/i
        regex = /.{0,10}#{@keyword}.{0,10}/i
        p.content.scan(regex).each do |cit|
          citation = "...#{cit}..."
          @results << [citation, url_for(:controller => "blog", :action => "show", :id => p.id)]
        end
      end
    end
  end

  def show_slide
      @sequence = session[:sequence]
      @sequence = 'default' unless @sequence
      @index = session[:index]
      if session[:player_status] && session[:player_status]=='PLAY'
        if @index < session[:slides_tot]-1
          @index += 1
        else
          @index = 0
        end
      else
      end
      session[:index] = @index
      slides = Slide.find_all_by_sequence(@sequence)
      @slide = slides[@index].image_path
      @slide_frequency = session[:slide_frequency]
      @appear_time = [@slide_frequency.to_f*0.3,3.0].min
      @fade_time = [@slide_frequency.to_f*0.3,3.0].min
      @show_time = @slide_frequency.to_f - (0.75*(@appear_time+@fade_time))
      render :partial => "show_slide"
    end

    def pause_play
      if session[:player_status]=='PLAY'
        session[:player_status] = 'PAUSE'
      else
        session[:player_status] = 'PLAY'
      end
      redirect_to :action => 'show_slide'
    end
    
    def next_slide
      @index = session[:index]
      if session[:player_status] != 'PLAY'
        if @index < session[:slides_tot]-1
          @index += 1
        else
          @index = 0
        end
      end
      session[:index] = @index
      redirect_to :action => 'show_slide'
    end
    
    def prev_slide
      @index = session[:index]
      if session[:player_status] == 'PLAY'
        case
          when @index == 0 :
            @index = session[:slides_tot]-2
          when @index == 1 :
            @index = session[:slides_tot]-1
          else
            @index -= 2
        end
       else
        case
          when @index == 0 :
            @index = session[:slides_tot]-1
          else
            @index -= 1
        end
       end
      session[:index] = @index
      redirect_to :action => 'show_slide'
    end
    
  private   #   P R I V A T E !

  def load_slideshow
    slides = Slide.find_all_by_sequence(@sequence)
    session[:slides_tot] = slides.length
    @slide = slides[0].image_path
    session[:index] = 0
    session[:sequence] = @sequence
    session[:player_status] = 'PLAY'
  end
  
end

