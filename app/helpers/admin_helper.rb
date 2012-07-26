module AdminHelper
  def admin_tabs(tab_name)
    current_tab_name = params[:type] || action_name ||"wallet"
    #current_tab_name = "In progress" if current_tab_name.eql?("pending")
    "inbox_tab_#{current_tab_name.eql?(tab_name) ? 'selected' : 'unselected'}"
  end
end
