class CheckOverDueTasksJob < Struct.new(:person_id)

  def perform
    Service.check_overdue_tasks

  end
  handle_asynchronously :perform,:run_at => Proc.new { 1.minutes.from_now }

end