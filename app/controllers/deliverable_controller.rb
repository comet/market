class DeliverableController < ApplicationController
  before_filter :only => [:edit, :update] do |controller|
    controller.ensure_logged_in "you_must_log_in_to_view_this_content"
  end

  before_filter :only => [:new, :create] do |controller|
    controller.ensure_logged_in(["you_must_log_in_to_create_new_#{params[:type]}", "create_one_here".to_sym, sign_up_path])
  end

  def home
    #Show all deliverables that the current user sold
    params[:listing_type] = "sold"
    @to_render = {:action => :index}
    @listing_style = "listing"
    load
  end

  def load
    per_page = 15
    @title = params[:listing_type]
    @to_render ||= {:partial => "deliverable/listed_deliverable"}
    @listings = Listing.open.order("created_at DESC").find_with(params, @current_user, @current_community).paginate(:per_page => per_page, :page => params[:page])
    @request_path = request.fullpath
    if request.xhr? && params[:page] && params[:page].to_i > 1
      render :partial => "listings/additional_listings"
    else
      render @to_render
    end
  end

  def create
    @deliverable = @current_user.create_deliverable params[:deliverable]

    if @deliverable.new_record?
    #  1.times { @listing.listing_images.build } if @listing.listing_images.empty?
      render :action => :new
    else
      path = new_request_category_path(:type => @deliverable.listing_type, :category => @listing.category)
      flash[:notice] = ["#{@deliverable.listing_type}_created_successfully", "create_new_#{@listing.listing_type}".to_sym, path]
      Delayed::Job.enqueue(ListingCreatedJob.new(@listing.id, request.host))
      redirect_to @deliverable
    end
  end

  #For the deliverable that the current user has bought
  def bought
    params[:listing_type] = "bought"
    load
  end

  #For all the deliverable that the current user has sold
  def sold
    params[:listing_type] = "sold"
    load
  end
  def new

    #@deliverable = Deliverable.new
    #TODO have a categories object for deliverable
    #respond_to do |format|
    #  format.html
     # format.js {render :layout => false}
    #end
    @deliverable = Deliverable.new(params[:deliverable])

    respond_to do |format|
      if @deliverable.save
        format.html { redirect_to(deliverable_url,
                    :notice => 'Deliverable was successfully created.') }
        format.js
      else
        format.html { redirect_to(deliverable_url) }
      end
    end
  end

end
