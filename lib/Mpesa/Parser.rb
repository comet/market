class Parser
  #CONST_PAYMENT_RECEIVED = 21;
  #CONST_PAYMENT_SENT = 22;
  #CONST_DEPOSIT = 23;
  #CONST_WITHDRAW = 24;
  #CONST_WITHDRAW_ATM = 25;
  #CONST_PAYBILL_PAID = 26;
  #CONST_BUY_GOODS = 27;
  #CONST_AIRTIME_YOU = 28;
  #CONST_AIRTIME_OTHER = 29;
  #CONST_UNKNOWN = 30;

  def date_input(time)
    Time.now
  end

  def self.parse(message)
    #Parse a text to come up with the transaction details

    @result = {"SUPER_TYPE" => "",
               "RECEIPT" => "",
               "TIME" => "",
               "PHONE" => "",
               "NAME" => "",
               "ACCOUNT" => "",
               "STATUS" => "",
               "AMOUNT" => "",
               "BALANCE" => "",
               "NOTE" => "",
               "COSTS" => 0}
    Rails.logger.debug{"Parsing the message "+message}

    if !message.match("You have received").nil?
      @result["SUPER_TYPE"] = "MONEY_IN"
      @result["TYPE"]= "PAYMENT_RECEIVED"
      temp = message.scan(/([A-Z0-9]+) Confirmed\.[\s\n]+You have received Ksh([0-9\.\,]+) from[\s\n]+([A-Z ]+) ([0-9]+)[\s\n]+on (\d\d?\/\d\d?\/\d\d) at (\d\d?:\d\d [AP]M)[\s\n]+New M-PESA balance is Ksh([0-9\.\,]+)/mi)
      if !temp.nil?

        @result["RECEIPT"] = temp[0][0]
        @result["AMOUNT"] = temp[0][1]
        @result["NAME"] = temp[0][2]
        @result["PHONE"] = temp[0][3]
        @result["TIME"] = temp[0][4]+" "+temp[0][5] #$this->dateInput($temp[5][0] . " " . $temp[6][0]);
        @result["BALANCE"] = temp[0][6] #Utility::numberInput($temp[7][0]);$temp[5][0] . " " . $temp[6][0]
      end
    else
      if !((message.match("/sent to .+ for account/")).nil?)

        @result["SUPER_TYPE"] = "MONEY_OUT"
        @result["TYPE"] = "PAYBILL_PAID"
        temp = message.scan(/([A-Z0-9]+) Confirmed\.[\s\n]+Ksh([0-9\.\,]+) sent to[\s\n]+(.+)[\s\n]+for account (.+)[\s\n]+on (\d\d?\/\d\d?\/\d\d) at (\d\d?:\d\d [AP]M)[\s\n]+New M-PESA balance is Ksh([0-9\.\,]+)/mi)
        Rails.logger.debug{temp}
        if !temp.nil?
          @result["RECEIPT"] = temp[0][0]
          @result["AMOUNT"] = temp[0][1] #Utility::numberInput($temp[2][0]);
          @result["NAME"] = temp[0][2]
          @result["ACCOUNT"] = temp[0][3]
          @result["TIME"] = temp[0][4] + " " + temp[0][5] #$this->dateInput($temp[5][0] . " " . $temp[6][0]);
          @result["BALANCE"] = temp[0][6] #Utility::numberInput($temp[7][0]);
        end

      else
        if !((message.match("/Ksh[0-9\.\,]+ paid to /")).nil?)
          @result["SUPER_TYPE"] = "MONEY_OUT"
          @result["TYPE"] = "BUY_GOODS"
          temp = message.scan(/([A-Z0-9]+) Confirmed\.[\s\n]+Ksh([0-9\.\,]+) paid to[\s\n]+([.]+)[\s\n]+on (\d\d?\/\d\d?\/\d\d) at (\d\d?:\d\d [AP]M)[\s\n]+New M-PESA balance is Ksh([0-9\.\,]+)/mi)
          Rails.logger.debug{temp}
          if !temp.nil?
            @result["RECEIPT"] = temp[0][0]
            @result["AMOUNT"] = temp[0][1] #Utility::numberInput($temp[2][0]);
            @result["NAME"] = temp[0][2]
            @result["TIME"] = temp[0][3] + " " + temp[0][4] #$this->dateInput($temp[4][0] . " " . $temp[5][0]);
            @result["BALANCE"] = temp[0][5] #Utility::numberInput($temp[6][0]);
          end

        else
          if !((message.match("sent to .+ on")).nil?)

            @result["SUPER_TYPE"] = "MONEY_OUT"
            @result["TYPE"] = "PAYMENT_SENT"
            temp = message.scan(/([A-Z0-9]+) Confirmed\.[\s\n]+Ksh([0-9\.\,]+) sent to ([A-Z ]+) ([0-9]+) on (\d\d?\/\d\d?\/\d\d) at (\d\d?:\d\d [AP]M)[\s\n]+New M-PESA balance is Ksh([0-9\.\,]+)/mi)
            Rails.logger.debug{temp}

            if !temp.nil?
              @result["RECEIPT"] = temp[0][0]
              @result["AMOUNT"] = temp[0][1] #Utility::numberInput($temp[2][0]);
              @result["NAME"] = temp[0][2]
              @result["PHONE"] = temp[0][3]
              @result["TIME"] = temp[0][4] +" " +temp[0][5] #$this->dateInput($temp[5][0] . " " . $temp[6][0]);
              @result["BALANCE"] = temp[0][6] #Utility::numberInput($temp[7][0]);
            end

          else
            if message.match("/Give Ksh[0-9\.\,]+ cash to/")

              @result["SUPER_TYPE"] = "MONEY_IN"
              @result["TYPE"] = "DEPOSIT"
              temp= message.scan(/([A-Z0-9]+) Confirmed\.[\s\n]+on (\d\d?\/\d\d?\/\d\d) at (\d\d?:\d\d [AP]M)[\s\n]+Give Ksh([0-9\.\,]+) cash to (.+)[\s\n]+New M-PESA balance is Ksh([0-9\.\,]+)/mi)
            Rails.logger.debug{temp}
              if !temp.nil?
                @result["RECEIPT"] = temp[0][0]
                @result["AMOUNT"] = temp[0][3] #Utility::numberInput($temp[4][0]);
                @result["NAME"] = temp[0][4]
                @result["TIME"] = temp[0][1] +temp[0][2] #$this->dateInput($temp[2][0] . " " . $temp[3][0]);
                @result["BALANCE"] = temp[0][5] #Utility::numberInput($temp[6][0]);
              end
            else
              if message.match("/Withdraw Ksh[0-9\.\,]+ from/")

                @result["SUPER_TYPE"] = "MONEY_OUT";
                @result["TYPE"] = "WITHDRAW"
                temp = message.scan("/([A-Z0-9]+) Confirmed\.[\s\n]+on (\d\d?\/\d\d?\/\d\d) at (\d\d?:\d\d [AP]M)[\s\n]+Withdraw Ksh([0-9\.\,]+) from (.+)[\s\n]+New M-PESA balance is Ksh([0-9\.\,]+)/mi")
                Rails.logger.debug{temp}
                if !temp.nil?
                  @result["RECEIPT"] = temp[0][0];
                  @result["AMOUNT"] = temp[0][3] #Utility::numberInput($temp[4][0]);
                  @result["NAME"] = temp[0][4];
                  @result["TIME"] = temp[0][1] +temp[0][2] #$this->dateInput($temp[2][0] . " " . $temp[3][0]);
                  @result["BALANCE"] = temp[0][5] #Utility::numberInput($temp[6][0]);
                end

              else
                if message.match("/Ksh[0-9\.\,]+ withdrawn from/")

                  @result["SUPER_TYPE"] = "MONEY_OUT"
                  @result["TYPE"] = "WITHDRAW_ATM"

                  temp = message.scan("/([A-Z0-9]+) Confirmed[\s\n]+on (\d\d?\/\d\d?\/\d\d) at (\d\d?:\d\d [AP]M).[\s\n]+Ksh([0-9\.\,]+) withdrawn from (\d+) - AGENT ATM\.[\s\n]+New M-PESA balance is Ksh([0-9\.\,]+)/mi")
                  Rails.logger.debug{temp}
                  if !temp.nil?
                    @result["RECEIPT"] = temp[0][0];
                    @result["AMOUNT"] = temp[0][3] #Utility::numberInput($temp[4][0]);
                    @result["NAME"] = temp[0][4];
                    @result["TIME"] = temp[0][1] +temp[0][2] #$this->dateInput($temp[2][0] . " " . $temp[3][0]);
                    @result["BALANCE"] = temp[0][5] #Utility::numberInput($temp[6][0]);
                  end

                else
                  if message.match("/You bought Ksh[0-9\.\,]+ of airtime on/")

                    @result["SUPER_TYPE"] = "MONEY_OUT"
                    @result["TYPE"] = "AIRTIME_YOU"

                    temp = message.scan("/([A-Z0-9]+) confirmed\.[\s\n]+You bought Ksh([0-9\.\,]+) of airtime on (\d\d?\/\d\d?\/\d\d) at (\d\d?:\d\d [AP]M)[\s\n]+New M-PESA balance is Ksh([0-9\.\,]+)/mi")
                    Rails.logger.debug{temp}
                    if !temp.nil?
                      @result["RECEIPT"] = temp[0][0];
                      @result["AMOUNT"] = temp[0][1] #Utility::numberInput($temp[2][0]);
                      @result["NAME"] = "Safaricom";
                      @result["TIME"] = temp[0][2] +temp[0][3] #$this->dateInput($temp[3][0] . " " . $temp[4][0]);
                      @result["BALANCE"] = temp[0][4] #Utility::numberInput($temp[5][0]);
                    end

                  else
                    if message.match("/You bought Ksh[0-9\.\,]+ of airtime for (\d+) on/")

                      @result["SUPER_TYPE"] = "MONEY_OUT"
                      @result["TYPE"] = "AIRTIME_OTHER"

                      temp = message.scan("/([A-Z0-9]+) confirmed\.[\s\n]+You bought Ksh([0-9\.\,]+) of airtime for (\d+) on (\d\d?\/\d\d?\/\d\d) at (\d\d?:\d\d [AP]M)[\s\n]+New M-PESA balance is Ksh([0-9\.\,]+)/mi")
                     Rails.logger.debug{temp}
                      if !temp.nil?
                        @result["RECEIPT"] = temp[0][0];
                        @result["AMOUNT"] = temp[0][1] #Utility::numberInput($temp[2][0]);
                        @result["NAME"] = temp[0][2];
                        @result["TIME"] = temp[0][3] + temp[0][4] #$this->dateInput($temp[4][0] . " " . $temp[5][0]);
                        @result["BALANCE"] = temp[0][5] #Utility::numberInput($temp[6][0]);
                      end

                    else

                      @result["SUPER_TYPE"] = "MONEY_NEUTRAL"
                      @result["TYPE"] = "UNKNOWN"
                      Rails.logger.debug{@result}
                    end

                  end
                end
              end
            end
          end
        end
      end
    end
    return @result
  end
end


