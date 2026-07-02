module Api
  class EbooksController < BaseController
    before_action :set_ebook, only: %i[show download destroy]

    def index
      render json: EbookSerializer.collection(Ebook.newest_first.limit(2))
    end

    def create
      result = Ebooks::CreateEbook.call(ebook_params)

      if result.success?
        render json: EbookSerializer.new(result.ebook).as_json,
               status: :created
      else
        render_validation_errors(result.ebook)
      end
    end

    def show
      render json: EbookSerializer.new(@ebook).as_json
    end

    def search
      render json: EbookSerializer.collection(Ebook.search(params[:q]))
    end

    def download
      return head :not_found unless @ebook.file.attached?

      send_data(
        @ebook.file.download,
        filename: @ebook.file.filename.to_s,
        type: @ebook.file.content_type,
        disposition: "attachment"
      )
    end

    def destroy
      @ebook.file.purge if @ebook.file.attached?
      @ebook.destroy!

      head :no_content
    end

    private

    def set_ebook
      @ebook = Ebook.find(params[:id])
    end

    def ebook_params
      params.require(:ebook).permit(:title, :author, :file)
    end
  end
end
