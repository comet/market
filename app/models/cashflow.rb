class Cashflow < ActiveRecord::Base
def self.find_by_direction(direction,user)
  if direction.eql?("received")
    Cashflow.find_by_sql("SELECT cashflows.amount,cashflows.created_at,cashflows.id,cashflows.listing_id,listings.title FROM `cashflows` INNER JOIN listings ON cashflows.listing_id=listings.id WHERE (`cashflows`.`user_id`='#{user}') ORDER BY `cashflows`.created_at DESC ")
  elsif direction.eql?("both")
    Cashflow.find_by_sql("SELECT * FROM `cashflows` WHERE (`cashflows`.`user_id`='#{user}' OR `cashflows`.`sender_user_id`='#{user}'  ) ORDER BY `cashflows`.created_at DESC ")
  else
  Cashflow.find_by_sql("SELECT cashflows.amount,cashflows.created_at,cashflows.id,cashflows.listing_id,listings.title FROM `cashflows` INNER JOIN listings ON cashflows.listing_id=listings.id WHERE (`cashflows`.`sender_user_id`='#{user}') ORDER BY `cashflows`.created_at DESC")
    end
end
end
