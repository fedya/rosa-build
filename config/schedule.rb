# -*- encoding : utf-8 -*-
#every 1.day, :at => '0:05 am' do
#  runner "Download.rotate_nginx_log"
#end
#
#every 1.day, :at => '0:10 am' do
#  runner "Download.parse_and_remove_nginx_log"
#end

every 1.day, :at => '5:00' do
  #rake "sudo_test:projects" 
  runner "Download.rotate_nginx_log"
  runner "Download.parse_and_remove_nginx_log"
end

every 1.day, :at => '4:00 am' do
  rake "import:sync:all", :output => 'log/sync.log'
end
