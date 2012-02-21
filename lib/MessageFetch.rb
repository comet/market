require 'net/http'
require 'net/https'
require 'Parser'
class MessageFetch
    @client_name = APP_CONFIG.pysmsd_app_name
    unless @client_name == nil
      http = SMSAPIHelper.get_http_connection()
      path = '/messages/in.json?name='+APP_CONFIG.pysmsd_app_name+'&password='+APP_CONFIG.pysmsd_app_password+'&keyword='+@client_name
      Rails.logger.debug { path }
      resp = http.get(path)
      json = JSON.parse(resp.body)
      #json['messages'].each do |message|
       # if message['number'].eql? "MPESA"
          #parse and store to db
          #message for tests
          message = "CA69NM170 Confirmed. You have received Ksh5,040.00 from ROY RUTTO 254721574146 on 15/2/12 at 1:42 PM New M-PESA balance is Ksh5050.00"
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
          @payment.amount = transaction["AMOUNT"].gsub(",", "")
          @payment.post_balance = transaction["BALANCE"].gsub(",", "")
          @payment.transaction_cost = transaction["COSTS"].eql? 0 ? 0 :transaction["COSTS"].gsub(",", "")
          @payment.note = transaction["NOTE"]
          Rails.logger.debug { transaction }
          if @payment.save
            Rails.logger.info { "Successfully created a transaction" }
            #redirect_to :action => "all"
          else
            Rails.logger.error { "Payment processing failed" }
            #flash[:error] = "Payment processing failed"
          end
        else
          Rails.logger.info { "Receiving irrelevant message "+message.to_s }
      #  end
        #  @person = Person.find_by_phone_number(message['number'])
        #  if @person
        #    message['user_id'] = @person.guid
        #  end
        Rails.logger.debug { message }
      end
end