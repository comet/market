module ServicesHelper
  def get_profile_tab_class(tab_name)
    current_tab_name = params[:type] || action_name ||"wallet"
    current_tab_name = "received" if current_tab_name.eql?("show")
    "inbox_tab_#{current_tab_name.eql?(tab_name) ? 'selected' : 'unselected'}"
  end
end
