class ReportsController < ApplicationController
  before_filter :only => [:home, :all] do |controller|
    controller.ensure_logged_in "you_must_log_in_to_view_transactions"
  end
  layout 'admin'
  def index
    @title="Monetary transactions"
     @payments = Cashflow.order("created_at DESC").all.paginate(:per_page => 15, :page => params[:page])
  end
  def money_in
    @title="Received money"
     @payments = Payment.order("created_at DESC").all.paginate(:per_page => 15, :page => params[:page])

  end
  def money_out
     @title="Sent money"
     @payments = Cashflow.withdrawal.order("created_at DESC").all.paginate(:per_page => 15, :page => params[:page])

  end
  def summary
    @title="Summary"
     @payments = Cashflow.all
    @monies=    Payment.all

  end

end
