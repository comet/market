class PaymentsController < ApplicationController
  def home

    if request.post?
          @code=params[:code]
      if @code.length>0
        @payment=Payment.find_by_receipt(@code)
        Rails.logger.debug{"Using the code "+@code.to_s}
      else
        flash[:error]="Please enter the correct transaction code in the field below"
        render :action=>"home"   #disallow null values on that page
      end
       if @payment
         #save the payment and tag it to this listing and this user
         unless @payment.amount.nil?
         @payjob = JobPayment.new
         @payjob.payment_id=@payment.id
         @payjob.user_id=@current_user.id.to_s
         @payjob.listing_id=params[:listing_id].to_i
           if @payjob.save
           flash[:notice]="Your payment of #{@payment.amount} was successfully processed. The owner has been informed and they shall deliver your product soon"
         redirect_to listing_path(params[:listing_id].to_i)
         else
           flash[:error]="There was an error processing your payment of #{@payment.amount} "
         end
         end
       else
         flash[:error]="No such transaction exists or you've entered the code wrongly"
       end
    else
      @listing_id=params[:id]
          if !@listing_id.nil?
    @listing=Listing.find_by_id(@listing_id)
          else
     flash[:error]="Please choose a task that you wish to buy"
            @error=true
            end
    end
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
