FactoryBot.define do
  factory :ebook do
    title { "Flutter Clean Architecture" }
    author { "Riya Sharma" }

    after(:build) do |ebook|
      ebook.file.attach(
        io: Rails.root.join("spec/fixtures/files/sample.pdf").open,
        filename: "sample.pdf",
        content_type: "application/pdf"
      )
      ebook.file_type = ebook.file.content_type
      ebook.file_size = ebook.file.byte_size
    end
  end
end
