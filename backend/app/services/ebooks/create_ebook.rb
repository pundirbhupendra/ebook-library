module Ebooks
  class CreateEbook
    Result = Struct.new(:ebook, keyword_init: true) do
      def success?
        ebook.persisted?
      end
    end

    def self.call(params)
      new(params).call
    end

    def initialize(params)
      @params = params
    end

    def call
      ebook = Ebook.new(title: params[:title], author: params[:author])

      if params[:file].present?
        ebook.file.attach(params[:file])
        ebook.file_type = ebook.file.content_type
        ebook.file_size = ebook.file.byte_size
      end

      ebook.save
      Result.new(ebook: ebook)
    end

    private

    attr_reader :params
  end
end
