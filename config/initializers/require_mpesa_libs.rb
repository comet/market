Dir[Rails.root + 'lib/Mpesa/*.rb'].each do |file|
  require file
end