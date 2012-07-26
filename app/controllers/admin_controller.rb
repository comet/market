class AdminController < ApplicationController
  layout 'admin'
  def listings
    params[:listing_type] = "request"
    @listings = Listing.open.order("created_at DESC").find_with(params, @current_user, @current_community).paginate(:per_page => 15, :page => params[:page])
  end
  def services
    @services = Service.performed.order("updated_at DESC").paginate(:per_page => 15, :page => params[:page])
  end
  def users
    @users = Person.order("updated_at DESC").all.paginate(:per_page => 15, :page => params[:page])
  end
end
