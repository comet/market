module mpesaImpl
  class Transaction
    #verifies the validity of a transaction
  end

  class Account

  end
  class Parser
    CONST_PAYMENT_RECEIVED = 21;
    CONST_PAYMENT_SENT = 22;
    CONST_DEPOSIT = 23;
    CONST_WITHDRAW = 24;
    CONST_WITHDRAW_ATM = 25;
    CONST_PAYBILL_PAID = 26;
    CONST_BUY_GOODS = 27;
    CONST_AIRTIME_YOU = 28;
    CONST_AIRTIME_OTHER = 29;
    CONST_UNKNOWN = 30;

    def date_input(time)
      Time.now
    end
    def parse(message)
      #Parse a text to come up with the transaction details
      result = ["SUPER_TYPE" => 0,
        "RECEIPT" => "",
        "TIME" => 0,
        "PHONE" => "",
        "NAME" => "",
        "ACCOUNT" => "",
        "STATUS" => "",
        "AMOUNT" => 0,
        "BALANCE" => 0,
        "NOTE" => "",
        "COSTS" => 0]

      if message.index("You have received").nil?
        #Money came in
        result["SUPER_TYPE"] ="MONEY_IN"
        result["TYPE"]= "PAYMENT_RECEIVED"
        temp = message.scan("/([A-Z0-9]+) Confirmed\.[\s\n]+You have received Ksh([0-9\.\,]+) from[\s\n]+([A-Z ]+) ([0-9]+)[\s\n]+on (\d\d?\/\d\d?\/\d\d) at (\d\d?:\d\d [AP]M)[\s\n]+New M-PESA balance is Ksh([0-9\.\,]+)/mi")
        if !temp.nil?
          result["RECEIPT"] = temp[1][0]
          result["AMOUNT"] = temp[2][0]
          result["NAME"] = temp[3][0]
          result["PHONE"] = temp[4][0]
          result["TIME"] = temp[5][0]+temp[6][0]#$this->dateInput($temp[5][0] . " " . $temp[6][0]);
          result["BALANCE"] = temp[7][0]#Utility::numberInput($temp[7][0]);$temp[5][0] . " " . $temp[6][0]
        end
      else if message.match("/sent to .+ for account/")
          result["SUPER_TYPE"] = "MONEY_OUT"
          result["TYPE"] = "PAYBILL_PAID"
          temp = message.scan("/([A-Z0-9]+) Confirmed\.[\s\n]+Ksh([0-9\.\,]+) sent to[\s\n]+(.+)[\s\n]+for account (.+)[\s\n]+on (\d\d?\/\d\d?\/\d\d) at (\d\d?:\d\d [AP]M)[\s\n]+New M-PESA balance is Ksh([0-9\.\,]+)/mi")
          if !temp.nil?
            result["RECEIPT"] = temp[1][0]
            result["AMOUNT"] = temp[2][0]#Utility::numberInput($temp[2][0]);
            result["NAME"] = temp[3][0]
            result["ACCOUNT"] = temp[4][0]
            result["TIME"] = temp[5][0] + " " + temp[6][0]#$this->dateInput($temp[5][0] . " " . $temp[6][0]);
            result["BALANCE"] = temp[7][0]#Utility::numberInput($temp[7][0]);
          end

        else if message.match("/Ksh[0-9\.\,]+ paid to /")
            result["SUPER_TYPE"] = "MONEY_OUT"
            result["TYPE"] = "BUY_GOODS"
            temp = message.scan("/([A-Z0-9]+) Confirmed\.[\s\n]+Ksh([0-9\.\,]+) paid to[\s\n]+([.]+)[\s\n]+on (\d\d?\/\d\d?\/\d\d) at (\d\d?:\d\d [AP]M)[\s\n]+New M-PESA balance is Ksh([0-9\.\,]+)/mi")
            if !temp[1][0].nil?
              result["RECEIPT"] = temp[1][0]
              result["AMOUNT"] = temp[2][0]#Utility::numberInput($temp[2][0]);
              result["NAME"] = temp[3][0]
              result["TIME"] = temp[4][0] + " " + temp[5][0]#$this->dateInput($temp[4][0] . " " . $temp[5][0]);
              result["BALANCE"] = temp[6][0]#Utility::numberInput($temp[6][0]);
            end

          else if message.match("/sent to .+ on/")
              result["SUPER_TYPE"] = "MONEY_OUT"
              result["TYPE"] = "PAYMENT_SENT"
              temp = message.scan("/([A-Z0-9]+) Confirmed\.[\s\n]+Ksh([0-9\.\,]+) sent to ([A-Z ]+) ([0-9]+) on (\d\d?\/\d\d?\/\d\d) at (\d\d?:\d\d [AP]M)[\s\n]+New M-PESA balance is Ksh([0-9\.\,]+)/mi")
              if !temp[1][0].nil?
                result["RECEIPT"] = temp[1][0]
                result["AMOUNT"] = temp[2][0]#Utility::numberInput($temp[2][0]);
                result["NAME"] = temp[3][0]
                result["PHONE"] = temp[4][0]
                result["TIME"] = temp[5][0] +" " +temp[6][0]#$this->dateInput($temp[5][0] . " " . $temp[6][0]);
                result["BALANCE"] = temp[7][0]#Utility::numberInput($temp[7][0]);
              end

            else if message.match("/Give Ksh[0-9\.\,]+ cash to/")
                result["SUPER_TYPE"] = "MONEY_IN"
                result["TYPE"] = "DEPOSIT"
                temp= message.scan("/([A-Z0-9]+) Confirmed\.[\s\n]+on (\d\d?\/\d\d?\/\d\d) at (\d\d?:\d\d [AP]M)[\s\n]+Give Ksh([0-9\.\,]+) cash to (.+)[\s\n]+New M-PESA balance is Ksh([0-9\.\,]+)/mi")
                if !temp[1][0].nil?
                  result["RECEIPT"] = temp[1][0]
                  result["AMOUNT"] = temp[4][0]#Utility::numberInput($temp[4][0]);
                  result["NAME"] = temp[5][0]
                  result["TIME"] = temp[2][0] +temp[3][0]#$this->dateInput($temp[2][0] . " " . $temp[3][0]);
                  result["BALANCE"] = temp[6][0]#Utility::numberInput($temp[6][0]);
                end
              else if message.match("/Withdraw Ksh[0-9\.\,]+ from/")
                  result["SUPER_TYPE"] = "MONEY_OUT";
                  result["TYPE"] = "WITHDRAW"
                  temp = message.scan("/([A-Z0-9]+) Confirmed\.[\s\n]+on (\d\d?\/\d\d?\/\d\d) at (\d\d?:\d\d [AP]M)[\s\n]+Withdraw Ksh([0-9\.\,]+) from (.+)[\s\n]+New M-PESA balance is Ksh([0-9\.\,]+)/mi")
                  if !temp[1][0].nil?
                    result["RECEIPT"] = temp[1][0];
                    result["AMOUNT"] = temp[4][0]#Utility::numberInput($temp[4][0]);
                    result["NAME"] = temp[5][0];
                    result["TIME"] = temp[2][0] +temp[3][0] #$this->dateInput($temp[2][0] . " " . $temp[3][0]);
                    result["BALANCE"] = temp[6][0]#Utility::numberInput($temp[6][0]);
                  end

                else if message.match("/Ksh[0-9\.\,]+ withdrawn from/")
                    result["SUPER_TYPE"] = "MONEY_OUT"
                    result["TYPE"] = "WITHDRAW_ATM"

                    temp = message.scan("/([A-Z0-9]+) Confirmed[\s\n]+on (\d\d?\/\d\d?\/\d\d) at (\d\d?:\d\d [AP]M).[\s\n]+Ksh([0-9\.\,]+) withdrawn from (\d+) - AGENT ATM\.[\s\n]+New M-PESA balance is Ksh([0-9\.\,]+)/mi")
                    if !temp[1][0].nil?
                      result["RECEIPT"] = temp[1][0];
                      result["AMOUNT"] = temp[4][0]#Utility::numberInput($temp[4][0]);
                      result["NAME"] = temp[5][0];
                      result["TIME"] = temp[2][0] +temp[3][0]#$this->dateInput($temp[2][0] . " " . $temp[3][0]);
                      result["BALANCE"] = temp[6][0]#Utility::numberInput($temp[6][0]);
                    end

                  else if message.match("/You bought Ksh[0-9\.\,]+ of airtime on/")
                      result["SUPER_TYPE"] = "MONEY_OUT"
                      result["TYPE"] = "AIRTIME_YOU"

                      temp = message.scan("/([A-Z0-9]+) confirmed\.[\s\n]+You bought Ksh([0-9\.\,]+) of airtime on (\d\d?\/\d\d?\/\d\d) at (\d\d?:\d\d [AP]M)[\s\n]+New M-PESA balance is Ksh([0-9\.\,]+)/mi")
                      if !temp[1][0].nil?
                        result["RECEIPT"] = temp[1][0];
                        result["AMOUNT"] = temp[2][0]#Utility::numberInput($temp[2][0]);
                        result["NAME"] = "Safaricom";
                        result["TIME"] = temp[3][0] +temp[4][0]#$this->dateInput($temp[3][0] . " " . $temp[4][0]);
                        result["BALANCE"] = temp[5][0]#Utility::numberInput($temp[5][0]);
                      end

                    else if message.match("/You bought Ksh[0-9\.\,]+ of airtime for (\d+) on/")
                        result["SUPER_TYPE"] = "MONEY_OUT"
                        result["TYPE"] = "AIRTIME_OTHER"

                        temp = message.scan("/([A-Z0-9]+) confirmed\.[\s\n]+You bought Ksh([0-9\.\,]+) of airtime for (\d+) on (\d\d?\/\d\d?\/\d\d) at (\d\d?:\d\d [AP]M)[\s\n]+New M-PESA balance is Ksh([0-9\.\,]+)/mi")
                        if !temp[1][0].nil?
                          result["RECEIPT"] = temp[1][0];
                          result["AMOUNT"] = temp[2][0]#Utility::numberInput($temp[2][0]);
                          result["NAME"] = temp[3][0];
                          result["TIME"] = temp[4][0] + temp[5][0]#$this->dateInput($temp[4][0] . " " . $temp[5][0]);
                          result["BALANCE"] = temp[6][0]#Utility::numberInput($temp[6][0]);
                        end

                      else
                        result["SUPER_TYPE"] = "MONEY_NEUTRAL"
                        result["TYPE"] = "UNKNOWN"
                      end
                  end
                end
              end
            end
          end
        end
      end
      end
    end
  end



end