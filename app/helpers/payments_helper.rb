module PaymentsHelper
def get_payment_tab_class(tab_name)
    current_tab_name = params[:type]
    #current_tab_name = "In progress" if current_tab_name.eql?("pending")
    "inbox_tab_#{current_tab_name.eql?(tab_name) ? 'selected' : 'unselected'}"
end
  def calculate_riches(transactions,direction,user)
    if transactions && transactions.size>0
  total_in=0
  total_out=0
      #Rails.logger.debug{"Transactions are "+transactions.size.to_s}
      transactions.each do |t|

         if t.amount && t.amount>0
           #check if its in or out
           if t.user_id.eql?(user) #this is receiving
      #       Rails.logger.debug{"Receiving "+t.amount.to_s}
           total_in+= t.amount
           else
      #       Rails.logger.debug{"Sent "+t.amount.to_s}
           total_out+=t.amount
           end
         end
      end
  if direction.eql?("out")
    return total_out
  elsif  direction.eql?("in")
     return total_in
  elsif  direction.eql?("both")
     return total_out+total_in
    end
    else
      0
     end
  end
end
