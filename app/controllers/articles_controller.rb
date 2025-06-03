class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy report ]

  # GET /articles or /articles.json
  def index
    @articles = Article.uncached { Article.all }
    authorize @articles
  end

  # GET /articles/1 or /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
    # authorize @articles
  end

  # GET /articles/1/edit
  def edit
    authorize @article
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)
    @article.user=current_user
    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    authorize @article
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
        authorize @article
    @article.destroy!

    respond_to do |format|
      format.html { redirect_to articles_path, status: :see_other, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def report
    @article.with_lock do
      @article.increment!(:reports_count)
      if @article.reports_count >= 3
          @article.update_column(:archived, true)       end
    end
    redirect_to @article,notice:"Article Reported"
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :description, :image)
    end
end
