require 'garb'
require 'csv'

Garb::Session.login("jaredk@accretivellc.com", "Suite115")

profile = Garb::Management::Profile.all.detect {|p| p.web_property_id == 'UA-380008-2'}


class Analytics
  extend Garb::Model

  metrics :entrances
  dimensions :landingPagePath, :secondPagePath, :nextPagePath, :exitPagePath

end

BIN_results = Analytics.results(profile, :start_date => (Date.new(2013,1,1)), :end_date => (Date.new(2013,1,31)), :limit => 10000)


entrance_total = 0
h = Hash.new()

CSV.open("/home/victor/RubymineProjects/insureon_analytics/csv/LandingPages.csv", "wb") do |csv|
  csv << ["Number of Entrances", "Landing Page Path"]
  BIN_results.each{
      |f|
    if h.keys.include?(f.landing_page_path)
      h[f.landing_page_path] += Integer(f.entrances)
    else
      h[f.landing_page_path] = Integer(f.entrances)
    end
  }
  h.keys.each{
    |a|
    csv << [h[a], a]
  }
end


=begin
CSV.open("/home/victor/RubymineProjects/insureon_analytics/csv/PagePaths.csv", "wb") do |csv|
  csv << ["Number of Entrances", "Landing Page Path", "Second Page Path", "Third Page Path", "Exit Path"]
  BIN_results.each{
    |f|
    csv << [f.entrances, f.landing_page_path, f.second_page_path, f.next_page_path, f.exit_page_path]
    entrance_total += Integer(f.entrances)
  }
  csv << [entrance_total]
end
=end


=begin
BIN_results.each {
  |f|
 #puts f.landing_page_path
  puts f
}
=end