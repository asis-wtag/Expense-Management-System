require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new
#scheduler.cron('0 0 1 * *') do
scheduler.at Time.now+15 do
  ReportJob.new.perform
end
