class Deliverable < ActiveRecord::Base
  include LocationsHelper
  include ApplicationHelper
  include ActionView::Helpers::TranslationHelper
  include Rails.application.routes.url_helpers

  #attr_accessor :comment,:satisfaction

  belongs_to :author, :class_name => "Person", :foreign_key => "author_id"
  validates_presence_of :author_id
  validates_length_of :title, :in => 2..100, :allow_nil => false
  validates_length_of :content, :maximum => 5000, :allow_nil => true
  validates_presence_of :receiver_id
  validates_presence_of :file_url
  validates_inclusion_of :valid_until, :allow_nil => :true, :in => DateTime.now..DateTime.now + 1.year

end
