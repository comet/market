class ServicesController < ApplicationController
# GET /services
  # GET /services.xml
  layout 'profile'
  def index
    @action_path = params[:type]
    if @action_path.nil?
      @action_path= "pending"
    end
    #@to_render = {:layout => "profile"}
    load
    #@services = Service.all
    #respond_to do |format|
     # format.html # index.html.erb
      #format.xml { render :xml => @services }
    #end
  end

  # GET /services/1
  # GET /services/1.xml
  def show
    @service = Service.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @service }
    end
  end
  #Loads services based on user request
  def performed

    load
  end
  def pending
    load
  end
  def load
    @title = @action_path
    if @title.eql?"done"
      @services = Service.performed.order("updated_at DESC").where("author_id=?",@current_user.id).paginate(:per_page => 15, :page => params[:page])
    elsif @title.eql?"cancelled"
      @services = Service.cancelled.order("updated_at DESC").where("author_id=?",@current_user.id).paginate(:per_page => 15, :page => params[:page])
    elsif @title.eql?"shopped"
      @services = Service.order("updated_at DESC").where("receiver_id=?",@current_user.id).paginate(:per_page => 15, :page => params[:page])
    elsif @title.eql?"pending"
      @services = Service.pending.order("updated_at DESC").where("author_id=?",@current_user.id).paginate(:per_page => 15, :page => params[:page])
    elsif @title.eql?"un_paid_for"
         @services = Service.unconfirmed.order("created_at DESC").where("author_id=?",@current_user.id).paginate(:per_page => 15, :page => params[:page])
    end
      #Service.order("created_at DESC").find_all#@current_user.services_that_are(@title).paginate(:per_page => 15, :page => params[:page])
    #request.xhr? ? (render :partial => "additional_messages") : (render :action => :index)
    ##(params, @current_user).paginate(:per_page => 15, :page => params[:page])
    @request_path = request.fullpath
    if request.xhr? && params[:page] && params[:page].to_i > 1
      render :partial => "services/additional_listings"
    else
     # render @to_render
    end

    end
  # GET /services/new
  # GET /services/new.xml
  def new
    @service = Service.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @service }
    end
  end

  # GET /services/1/edit
  def edit
    @service = Service.find(params[:id])
  end

  # POST /services
  # POST /services.xml
  def create
        respond_to do |format|
      if @service.save
        format.html { redirect_to(@service, :notice => 'Service successfully uploaded.') }
        format.xml { render :xml => @service, :status => :created, :location => @service }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /services/1
  # PUT /services/1.xml
  def update
    @service = Service.find(params[:id])
    unless params[:file_url_exists]
    upload
    @service.file_id = @service_file.id.to_s
    @service.file_url = @service_file.file_name.to_s
    end
    @service.status="done"
    respond_to do |format|
      if @service.update_attributes(params[:service])
        #perform money transfer here
        Rails.logger.debug{@service.inspect}
        if !@service.update_payment_attributes
            Rails.logger.debug{"Failed transacting money"}
        end
        format.html { redirect_to(@service, :notice => 'Service was successfully uploaded.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.xml
  def destroy
    @service = Service.find(params[:id])
    @service.destroy

    respond_to do |format|
      format.html { redirect_to(services_url) }
      format.xml { head :ok }
    end
  end
  def approve_receipt
    @service = Service.find(params[:id])
    if !@service.update_payment_attributes
            Rails.logger.debug{"Failed transacting money"}
        end

  end

  def upload
    #uploaded_io = params[:service][:file_url]
    #File.open(Rails.root.join('public', 'images', uploaded_io.original_filename), 'w') do |file|
     # file.write(uploaded_io.read)
    #end
    @service_file = ServiceFile.new
    #set the service_id
    if @service_file.id
    @service_file.service_id = @service.id
    else
    @service_file.service_id = "0".to_i
      end
    ServiceFile.save(params[:service],@service_file)
  end
  def download
    #check that the user is authorized
    root_file_path='public/images/deliverables'
    file=ServiceFile.find(params[:serv_id])
    if file
      file_name=file.file_name
      type=file.file_content_type
    else
      flash[:error]="No such file exists"
      redirect_to services_path(:type=>"shopped",:author_id=>@current_user)
    end
    path = File.join(root_file_path, file_name)
    if authorized_file_access(@current_user,file)
    send_file path, :type=>type,:x_sendfile=>true
    else
      flash[:error]="You are not authorised to view this file"
      redirect_to services_path(:type=>"shopped",:author_id=>@current_user)
    end

  end
  def authorized_file_access(id,file)
    return true
  end
end