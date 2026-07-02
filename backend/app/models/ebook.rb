class Ebook < ApplicationRecord
  MAX_FILE_SIZE_BYTES = 20 * 1024 * 1024

  has_one_attached :file

  validates :title, presence: true
  validates :file, presence: true
  validate :file_must_be_pdf
  validate :file_size_within_limit

  scope :newest_first, -> { order(created_at: :desc) }

  def self.search(query)
    normalized_query = "%#{sanitize_sql_like(query.to_s.strip)}%"

    left_joins(file_attachment: :blob)
      .where(
        "ebooks.title ILIKE :query OR ebooks.author ILIKE :query OR active_storage_blobs.filename ILIKE :query",
        query: normalized_query
      )
      .distinct
      .newest_first
  end

  private

  def file_must_be_pdf
    return unless file.attached?
    return if file.content_type == "application/pdf"

    errors.add(:file, "must be a PDF")
  end

  def file_size_within_limit
    return unless file.attached?
    return if file.byte_size <= MAX_FILE_SIZE_BYTES

    errors.add(:file, "must be 20 MB or smaller")
  end
end
