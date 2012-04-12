class RatingsController < ApplicationController

  def create
    @service = Service.find_by_id(params[:rating][:service_id])

                @rating = Rating.new(params[:rating])
                @rating.service_id = @service.id
                @rating.user_id = @current_user.id
                if @rating.save
                    respond_to do |format|
                        format.html { redirect_to service_path(@service), :notice => "Your rating has been saved" }
                        format.js  { render :layout => false }
                    end
                end

  end

  def update
    @service = Service.find_by_id(params[:rating][:service_id])

                @rating = @current_user.ratings.find_by_service_id(@service.id)
                if @rating.update_attributes(params[:rating])
                    respond_to do |format|
                        format.html { redirect_to service_path(@service), :notice => "Your rating has been updated" }
                        format.js { render :layout => false }
                    end
                end
  end

  def destroy
  end

  def new
  end

end
