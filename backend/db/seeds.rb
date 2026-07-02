Ebook.find_each do |ebook|
  ebook.file.purge if ebook.file.attached?
  ebook.destroy!
end

puts "No default ebooks seeded."
