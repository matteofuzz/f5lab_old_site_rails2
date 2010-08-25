class BlogController < ApplicationController

  layout "site", :except => [:feed]
  before_filter :load_pages, :load_recents, :load_tags,
                 :load_archives, :load_cloud, :load_commented
  
  def index
    @posts = Post.paginate :order => 'created_at DESC', :page => params[:page], :per_page => 3
  end

  def show
    @post = Post.find(params[:id])  
  end
  
  def show_selection
    case
      when params[:tag]
        @posts = Post.paginate :order => 'created_at DESC', :page => params[:page], :per_page => 3,
                              :joins => :tags, :conditions => {"tags.name" => params[:tag] }
        @desc_selection = 'Tag = ' + params[:tag] + ' (' + @posts.length.to_s + ' result'  
      when params[:month]
        day1 = params[:year]+'-'+params[:month]+'-01'
        day2 = params[:year]+'-'+(params[:month].to_i+1).to_s+'-01'
        @posts = Post.paginate :order => 'created_at DESC', :page => params[:page], :per_page => 3,
                              :conditions => {:created_at => day1...day2 }      
        @desc_selection = 'Month = ' + Date::MONTHNAMES[params[:month].to_i] + ' (' + @posts.length.to_s + ' result'                                              
      when params[:loc]
        @posts = Post.paginate :order => 'created_at DESC', :page => params[:page], :per_page => 3,
                                :conditions => {:locale => params[:loc] }
        @desc_selection = 'Lang = ' + params[:loc] + ' (' + @posts.length.to_s + ' result'
      else
    end
    @desc_selection += 's' if @posts.length>1
    @desc_selection += ')'
    render :action => 'index'
  end
  
  def feed
    @posts = Post.find(:all)
  end
  
  
  
  private
  
  def load_archives
    month = Date.today.month
    year = Date.today.year
    @archives = []
    6.times do
      day1 = year.to_s+'-'+month.to_s+'-01'
      day2 = year.to_s+'-'+(month+1).to_s+'-01'
      @posts = Post.find :all, :order => 'created_at DESC', 
                               :conditions => {:created_at => day1...day2 }
      unless @posts.empty?
        @archives << [month, year]
      end
      month -= 1
      if month == 0
        month = 12
        year -= 1
      end
    end
  end
  
  def load_tags
    @tags = Tag.all.map{|t| t.name}.sort.uniq
  end
  
  def load_recents
    @recents = Post.find(:all, :limit => 5, :order => "created_at DESC")
  end
   
  def load_pages    
    load_pages_of_menu
    @title = 'blog'
  end
  
  def load_cloud
    @cloud = {}
      tags = Tag.all.map{|t| t.name}
      tags.each do |t|
        if @cloud.has_key?(t)
          @cloud[t] += 1
        else
          @cloud[t] = 1
        end
      end
      @cloud.each do |t,f|
        case 
          when f==1
            @cloud[t] = 'size1'
          when f==2
            @cloud[t] = 'size2'
          else
            @cloud[t] = 'size3'
        end
      end
  end
  
  def load_commented
    @comments = Comment.find(:all, :limit => 5, :order => "created_at DESC")
    @commented = @comments.map{|c| Post.find(c.post_id)}.uniq
  end
  
end
