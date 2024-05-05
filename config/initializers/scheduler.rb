require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new
scheduler.at Time.now + 30 do
# scheduler.cron('0 0 1 * *') do
  ReportJob.new.perform
end
