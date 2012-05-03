class ServiceReminderJob < Struct.new(:service_id)
  
  def perform
    listing_time=1
    service=Service.find(service_id)

    listing = Listing.find(service.listing_id)
    if listing
      listing_time=listing.time_frame
    end
    if service
    PersonMailer.remind_job_pending_hours(service)
    end
    Delayed::Job.enqueue(ServiceReminderJob.new(service.id), 0, listing_time.day.from_now)
  end
  
end