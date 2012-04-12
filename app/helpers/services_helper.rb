module ServicesHelper
  def get_services_profile_tab_class(tab_name)
    current_tab_name = params[:type] || action_name ||"wallet"
    #current_tab_name = "In progress" if current_tab_name.eql?("pending")
    "inbox_tab_#{current_tab_name.eql?(tab_name) ? 'selected' : 'unselected'}"
  end
  def rating_ballot
    if @rating = @current_user.ratings.find_by_service_id(params[:id])
        @rating
    else
        @current_user.ratings.new
    end
  end
  def current_user_rating
    if @rating = @current_user.ratings.find_by_service_id(params[:id])
        @rating.value
    else
        "N/A"
    end
end
end
