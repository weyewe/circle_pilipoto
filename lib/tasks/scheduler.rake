desc "This task is called by the Heroku cron add-on"
task :call_page => :environment do
  uri = URI.parse('http://www.pilipoto.com/')
  Net::HTTP.get(uri)
  puts "this is it"
end


# task :extract_transloadit_image => :environment do
#   total_pic_pending = Picture.find(:all, :conditions => {
#     :is_completed => false 
#   }).count
#   
#   if total_pic_pending > 0
#     puts "There are pending assembly_url"
#     Picture.find(:all, :conditions => {
#       :is_completed => false 
#     }).each do |pic|
#       pic.extract_from_assembly_url
#     end
#   else
#     puts "There are no pending assembly_url"
#   end
#   
#   
# end


task :parse_uni => :environment do
  # // Open the file with fast csv 
  # Create the user. for those Failed user , save it into the failed user db
  uri = URI.parse('http://www.pilipoto.com/')
  Net::HTTP.get(uri)
  puts "this is it"
end




