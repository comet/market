class ServicesController < ApplicationController
  # GET /services
  # GET /services.xml
  def index
    @services = Service.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @services }
    end
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
    @service = Service.new(params[:service])
    upload
    @service.file_id = @service_file.id.to_s
    @service.file_url = @service_file.file_name

    respond_to do |format|
      if @service.save
        format.html { redirect_to(@service, :notice => 'Service successfully delivered.') }
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

    respond_to do |format|
      if @service.update_attributes(params[:service])
        format.html { redirect_to(@service, :notice => 'Service was successfully updated.') }
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

  def upload
    #uploaded_io = params[:service][:file_url]
    #File.open(Rails.root.join('public', 'images', uploaded_io.original_filename), 'w') do |file|
     # file.write(uploaded_io.read)
    #end
    @service_file = ServiceFile.new
    #set the service_id
    @service_file.service_id = @service.id
    ServiceFile.save(params[:service],@service_file)
  end
end
