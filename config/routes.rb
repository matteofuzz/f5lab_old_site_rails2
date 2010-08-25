ActionController::Routing::Routes.draw do |map|
  map.resources :posts, :has_many => :comments
  map.resources :slides
  map.resources :pages

  map.blog 'blog', :controller => 'blog', :action => 'index'
  map.connect 'blog/show_selection', :controller => 'blog', :action =>'show_selection'
  map.connect 'blog/:id', :controller => 'blog', :action =>'show'
  map.connect 'blog/feed.:format', :controller => 'blog', :action => 'feed'
  
  map.connect 'site/:action/:title', :controller => 'site'

  map.pause_play 'site/pause_play', :controller => 'site', :action => 'pause_play'
  map.next_slide 'site/next_slide', :controller => 'site', :action => 'next_slide'
  map.prev_slide 'site/prev_slide', :controller => 'site', :action => 'prev_slide'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "site", :action => 'go', :title => 'home'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
