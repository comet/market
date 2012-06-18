module ReportsHelper
  def get_report_tab_class(tab_name)
    current_tab_name = params[:action]
    #current_tab_name = "In progress" if current_tab_name.eql?("pending")
    "inbox_tab_#{current_tab_name.eql?(tab_name) ? 'selected' : 'unselected'}"
  end
  def calculate_report_riches(transactions,monies)
    hash={}
    if transactions && transactions.size>0
  total_in=0
  total_out=0
  total_transacted=0
  total_charged=0
      #Rails.logger.debug{"Transactions are "+transactions.size.to_s}
      transactions.each do |t|

         if t.amount && t.amount>0
           #check if its in or out
           if t.user_id && t.sender_user_id #this is a transaction
      #       Rails.logger.debug{"Receiving "+t.amount.to_s}
           total_transacted+= t.amount
           end
           if t.transaction_type.to_s.eql?("1")
      #       Rails.logger.debug{"Withdrawn "+t.amount.to_s}
             total_out+=t.amount
             end
         end
        Rails.logger.debug{"Amount is insufficient to qualify it as a transaction"}
      end
      monies.each do |t|
      if monies.size>0 && t.receipt
             #       Rails.logger.debug{"Sent "+t.amount.to_s}
        unless t.amount.nil?
           total_in+=t.amount
          end
      end
        end
    end
    hash={:withdrawn=>total_out,:in=>total_in,:both=>total_transacted}
    end

end
