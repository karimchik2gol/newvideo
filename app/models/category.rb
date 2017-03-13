class Category < ActiveRecord::Base

	def self.parse_categories
        Category.destroy_all
		url = "https://gist.github.com/dgp/1b24bf2961521bd75d6c"
		html = open(url)
		doc = Nokogiri::HTML(html, nil, 'UTF-8')
		table = doc.css(".js-file-line-container")
		table.css("tr").each do |f|
			id, name = f.css("td")[1].text.split(" - ")
			Category.create(name: name, category_id: id.to_i)
            break if Category.all.count == 32
		end
	end
end
