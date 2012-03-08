class PaymentsController < ApplicationController
  def home
    @listingsummary=Listing.find_with(params,@current_user, @current_community)

  end

  def all
    @to_render = {:layout => "wallet"}
    @payments = Payment.all
    render @to_render

  end

  def new

    #message = "BR53WA470 Confirmed. Ksh5,040.00 sent to KELVIN NKINYILI 0700335924 on 1/10/11 at 1:29 PM New M-PESA balance is Ksh0.00"
    message = "CA69NM170 Confirmed. You have received Ksh5,040.00 from ROY RUTTO 254721574146 on 15/2/12 at 1:42 PM New M-PESA balance is Ksh5050.00"
    #message = "You have received blah blah"
    transaction = Parser.parse(message)
    #Create a payment object
    #Not necessary if the items are correctly name
    @payment = Payment.new
    @payment.account_id = transaction["ACCOUNT"]
    @payment.super_type = transaction["SUPER_TYPE"]
    @payment.receipt = transaction["RECEIPT"]
    @payment.transaction_type = transaction["TYPE"]
    @payment.time =transaction["TIME"]
    @payment.phonenumber = transaction["PHONE"]
    @payment.name = transaction["NAME"]
    @payment.account =transaction["ACCOUNT"]
    @payment.status = transaction["STATUS"]
    @payment.amount = transaction["AMOUNT"].gsub(",","")
    @payment.post_balance = transaction["BALANCE"].gsub(",","")
    @payment.transaction_cost = transaction["COSTS"].eql?0? 0:transaction["COSTS"].gsub(",","")
    @payment.note = transaction["NOTE"]

     Rails.logger.debug{transaction}
    if @payment.save
      Rails.logger.info{"Successfully created a transaction"}
      redirect_to :action => "all"
    else
      Rails.logger.error{"Payment processing failed"}
      flash[:error] = "Payment processing failed"
    end



  end

  def show
  end

  def confirm
  end

end
