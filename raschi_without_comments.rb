require 'nokogiri'
require 'open-uri'

base_url = 'https://dailyitalianwords.com/category/italian-word-of-the-day/'
doc = Nokogiri::HTML(open(base_url).read)
entry_titles = doc.css(".entry-title-link")
dictionary = {}
export = "italiano:" + " "*33 + "English:\n\n"


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


pagination_numbers_to_compare = []

doc.css(".archive-pagination > ul > li > a").each do |item|
	if item.to_s.match(/\d+/)
		pagination_numbers_to_compare.push(item.to_s.match(/\d+/).to_s.to_i)
	end
end

pagination_end = pagination_numbers_to_compare.max()
pagination_numbers = (2..pagination_end)


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


today = Time.now.strftime("%Y%m%d")
File.write("Italian_Definitions #{today}.txt", 
	"From dailyitalianwords.com:\n\n#{export}")

