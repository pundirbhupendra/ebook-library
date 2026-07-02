class EbookSerializer
  def self.collection(ebooks, view_context = nil)
    ebooks.map { |ebook| new(ebook, view_context).as_json }
  end

  def initialize(ebook, view_context = nil)
    @ebook = ebook
    @view_context = view_context
  end

  def as_json(*)
    {
      id: ebook.id,
      title: ebook.title,
      author: ebook.author,
      file_type: ebook.file_type,
      file_size: ebook.file_size,
      filename: filename,
      uploaded_at: ebook.created_at&.iso8601,
      download_url: download_url
    }
  end

  def download_url
    return unless ebook.file.attached?

    if view_context&.respond_to?(:rails_storage_proxy_path)
      view_context.rails_storage_proxy_path(
        ebook.file,
        disposition: "inline",
        only_path: true
      )
    else
      Rails.application.routes.url_helpers.rails_storage_proxy_path(
        ebook.file,
        disposition: "inline",
        only_path: true
      )
    end
  end

  private

  attr_reader :ebook, :view_context

  def filename
    ebook.file.filename.to_s if ebook.file.attached?
  end
end
