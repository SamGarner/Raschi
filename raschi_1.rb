 # pages other than the first/base: https://dailyitalianwords.com/category/italian-word-of-the-day/page/2/
doc = Nokogiri::HTML(open(base_url).read)
require 'nokogiri'
require 'open-uri'

base_url = 'https://dailyitalianwords.com/category/italian-word-of-the-day/'

entry_titles = doc.css(".entry-title-link")

#italianword = doc.css(".entry-title-link")[0].match(
#	/#{Regexp.quote("Italian Word of the Day: ")}(.*)\s[(]\w/)  

# => #<MatchData "Italian Word of the Day: Mostro (m" 1:"Mostro">
# --get the better way to match than the 'weird' output
# --can possibly pull everything between 1:" and ">  but would need more Regex?
# --watch/read the open tab about webscraping with ruby before moving on?


# for each 'entry title' will want to 
# string = entry_titles[0].to_s

# match = string.match(/#{Regexp.quote("Italian Word of the Day: ")}(.*)\s[(]/)
	# example output: => #<MatchData "Italian Word of the Day: Mostro (" 1:"Mostro">
# match_string = match.to_s
# match_string.slice(25, match_string.length-27)

dictionary = {}
# it one, just double check the regex right quick
entry_titles.each { |title|
	string = title.to_s
	matched_it =  string.match(/#{Regexp.quote("Italian Word of the Day: ")}(.*)\s[(]/).to_s
	matched_en = string.match(/[(](.*)[)]/).to_s
	italian_word = matched_it.slice(25, matched_it.length-27).downcase
	english_word = matched_en.slice(1, matched_en.length-2)
	dictionary[italian_word] = english_word
	puts "Italian word: #{italian_word}   ||   English word: #{english_word}"
}

p dictionary


# testing below

pagination_links = []

doc.css(".archive-pagination > ul > li > a").each do |item|
	#pagination_links << item.to_s.match(/Regexp.quote("span> ")(.*)[<]/).to_s
	link = item.to_s#.inspect#.match(/Regexp.quote("span")(.*)[<]/).to_s
	puts link
	puts link.match(/Regexp.quote("span")(.*)[<]/).to_s
end

p pagination_links

# pagination_links = doc.css(".archive-pagination > ul > li > a")
