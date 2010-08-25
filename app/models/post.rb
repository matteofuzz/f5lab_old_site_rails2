class Post < ActiveRecord::Base
  
  validates_presence_of :name, :title, :author
  validates_length_of :title, :minimum => 5
  
  has_many :comments, :dependent => :destroy
  has_many :tags, :dependent => :destroy
  
  accepts_nested_attributes_for :tags, :allow_destroy => :true, 
    :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

end
