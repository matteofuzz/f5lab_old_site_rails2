class Comment < ActiveRecord::Base
  belongs_to :post
  validates_presence_of :commenter, :body
  validates_length_of :commenter, :minimum => 3
end
