require 'nokogiri'
require 'open-uri'

# entry_titles represents the 'posts' on any of the given blog pages
# dictionary will be a hash holding the italian-english/key-value
	# not used in current version - added for a possible future enhancement that
	# would pull more information for each pair after following link to blog post
# export accumulates the definitions to output. Here the first line is added.
base_url = 'https://dailyitalianwords.com/category/italian-word-of-the-day/'
doc = Nokogiri::HTML(open(base_url).read)
entry_titles = doc.css(".entry-title-link")
dictionary = {}
export = "italiano:" + " "*33 + "English:\n\n"

# loop to iterate over each blog post on the current page, get the italian word
# and English definition, clean them up, and add them to the dictionary hash and
# export text
entry_titles.each { |title|
	string = title.to_s
	matched_it =  string.match(/#{Regexp.quote("Italian Word of the Day")}(.*)\s[(]/).to_s
	matched_en = string.match(/[(](.*)[)]/).to_s
	italian_word = matched_it.slice(25, matched_it.length-27).downcase.lstrip
	english_word = matched_en.slice(1, matched_en.length-2)
	dictionary[italian_word] = english_word
	export << "#{italian_word}" + " "*(35-italian_word.length) + 
	"||     #{english_word}\n"
}

# the loop below is used to determine the number of "word of the day" pages 
# currently exist on the site by pulling from the pagination. Pagination shows 
# the next several page numbers but also the last/max page number.
pagination_numbers_to_compare = []

doc.css(".archive-pagination > ul > li > a").each do |item|
	if item.to_s.match(/\d+/)
		pagination_numbers_to_compare.push(item.to_s.match(/\d+/).to_s.to_i)
	end
end

pagination_end = pagination_numbers_to_compare.max()
pagination_numbers = (2..pagination_end)

# Now we have the number of pages that exist and the loop below will iterate 
# though them while following the process from above of finding the italian and 
# English words, cleaning them up, and adding them to the dictionary hash and
# export text
# format of the URLs to iterate over:
	# https://dailyitalianwords.com/category/italian-word-of-the-day/page/2/

pagination_numbers.each do |page_num|
	page_url = "https://dailyitalianwords.com/category/italian-word-of-the-day/page/#{page_num}/"
	pagedoc = Nokogiri::HTML(open(page_url).read)
	post_titles = pagedoc.css(".entry-title-link")
	post_titles.each do |title|
		string = title.to_s
		matched_it =  string.match(/#{Regexp.quote("Italian Word of the Day")}(.*)\s[(]/).to_s
		matched_en = string.match(/[(](.*)[)]/).to_s
		italian_word = matched_it.slice(25, matched_it.length-27).downcase.lstrip
		english_word = matched_en.slice(1, matched_en.length-2)
		dictionary[italian_word] = english_word
		export << "#{italian_word}" + " "*(35-italian_word.length) + 
			"||     #{english_word}\n"
	end
end

# write the resulting definitions list to a .txt file with today's date:
today = Time.now.strftime("%Y%m%d")
File.write("Italian_Definitions #{today}.txt", 
	"From dailyitalianwords.com:\n\n#{export}")
