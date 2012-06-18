class MoneyAccount < ActiveRecord::Base
  def self.withdraw(user,amount)
    #TODO get the file from the config file
    @person = Person.find_by_id(user)
    Rails.logger.debug{"Paying this guy "}
    Rails.logger.debug{@person.inspect}
    if @person
    FasterCSV.open("paybill.csv", "a") do |csv|
    csv << [@person.username, @person.family_name,Date.new,DateTime.now.to_s, @person.phone_number.blank? ? "000000000" : @person.phone_number, amount]
    end
    end
    end
end
