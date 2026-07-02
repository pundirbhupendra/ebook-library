require "rails_helper"
require "tempfile"

RSpec.describe "Api::Ebooks", type: :request do
  let(:pdf_file) do
    fixture_file_upload("files/sample.pdf", "application/pdf")
  end

  describe "GET /api/ebooks" do
    it "returns all ebooks sorted newest first" do
      older = create(:ebook, title: "Older Book", created_at: 2.days.ago)
      newer = create(:ebook, title: "Newer Book", created_at: 1.hour.ago)

      get "/api/ebooks"

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.pluck("id")).to eq([newer.id, older.id])
    end
  end

  describe "POST /api/ebooks" do
    it "uploads a PDF and saves metadata" do
      post "/api/ebooks", params: {
        ebook: {
          title: "Rails API Playbook",
          author: "Aditi Menon",
          file: pdf_file
        }
      }

      expect(response).to have_http_status(:created)
      body = response.parsed_body
      expect(body["title"]).to eq("Rails API Playbook")
      expect(body["author"]).to eq("Aditi Menon")
      expect(body["file_type"]).to eq("application/pdf")
      expect(body["file_size"]).to be_positive
      expect(body["download_url"]).to be_present
    end

    it "returns validation errors when title is missing" do
      post "/api/ebooks", params: {
        ebook: {
          author: "Aditi Menon",
          file: pdf_file
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body["errors"]).to include("Title can't be blank")
    end

    it "returns validation errors when file is not a PDF" do
      text_file = fixture_file_upload("files/sample.txt", "text/plain")

      post "/api/ebooks", params: {
        ebook: {
          title: "Plain Text Notes",
          file: text_file
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body["errors"]).to include("File must be a PDF")
    end

    it "returns validation errors when the file is too large" do
      large_pdf = Tempfile.new(["large", ".pdf"])
      large_pdf.write("a" * (21 * 1024 * 1024))
      large_pdf.rewind

      post "/api/ebooks", params: {
        ebook: {
          title: "Oversized Ebook",
          file: Rack::Test::UploadedFile.new(large_pdf.path, "application/pdf")
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body["errors"]).to include("File must be 20 MB or smaller")
    ensure
      large_pdf.close!
    end
  end

  describe "GET /api/ebooks/:id" do
    it "returns ebook details" do
      ebook = create(:ebook, title: "System Design Interview")

      get "/api/ebooks/#{ebook.id}"

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["title"]).to eq("System Design Interview")
    end
  end

  describe "GET /api/ebooks/search" do
    it "searches by title, author, and filename" do
      create(:ebook, title: "Flutter Clean Architecture", author: "Riya Sharma")
      create(:ebook, title: "Ruby on Rails Basics", author: "Arjun Mehta")

      get "/api/ebooks/search", params: { q: "rails" }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.map { |book| book["title"] }).to contain_exactly("Ruby on Rails Basics")
    end
  end

  describe "GET /api/ebooks/:id/download" do
    it "returns a downloadable PDF attachment" do
      ebook = create(:ebook)

      get "/api/ebooks/#{ebook.id}/download"

      expect(response).to have_http_status(:ok)
      expect(response.headers["Content-Disposition"]).to include("attachment")
      expect(response.media_type).to eq("application/pdf")
      expect(response.body).to be_present
    end
  end

  describe "DELETE /api/ebooks/:id" do
    it "deletes the ebook and attached file" do
      ebook = create(:ebook)

      expect do
        delete "/api/ebooks/#{ebook.id}"
      end.to change(Ebook, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
