require 'nokogiri'
require 'open-uri'

base_url = 'https://dailyitalianwords.com/category/italian-word-of-the-day/'
 # pages other than the first/base: https://dailyitalianwords.com/category/italian-word-of-the-day/page/2/
doc = Nokogiri::HTML(open(base_url).read)

entry_titles = doc.css(".entry-title-link")

#italianword = doc.css(".entry-title-link")[0].match(
#	/#{Regexp.quote("Italian Word of the Day: ")}(.*)\s[(]\w/)  

# => #<MatchData "Italian Word of the Day: Mostro (m" 1:"Mostro">
# --get the better way to match than the 'weird' output
# --can possibly pull everything between 1:" and ">  but would need more Regex?
# --watch/read the open tab about webscraping with ruby before moving on?

# for each 'entry title' will want to 
# string = entry_titles[0].to_s

# match = string.match(/#{Regexp.quote("Italian Word of the Day: ")}(.*)\s[(]\)
	# example output: => #<MatchData "Italian Word of the Day: Mostro (" 1:"Mostro">
# match_string = match.to_s
# match_string.slice(25, match_string.length-27)
