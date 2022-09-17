class ArticlesController < ApplicationController
  before_action :set_article, only: [ :show, :edit, :update, :destroy ]
  before_action :require_user, except: [ :show, :index ]
  before_action :require_same_user, only: [ :edit, :update, :destroy ]

  # GET /articles or /articles.json
  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  # GET /articles/1 or /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      flash[:notice] = 'Article was created successfully'
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end

    #respond_to do |format|
    #  if @article.save
    #    format.html { redirect_to article_path(@article), notice: "Article was successfully created." }
    #    format.json { render :show, status: :created, location: @article }
    #  else
    #    format.html { render :new, status: :unprocessable_entity }
    #    format.json { render json: @article.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    if @article.update(article_params)
      flash[:notice] = "Article was updated successfully."
      redirect_to @article
    else
      render 'edit'
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy
    redirect_to article_path

    #respond_to do |format|
    #  format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
    #  format.json { head :no_content }
    #end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :description)
    end

    def require_same_user
      if current_user != @article.user && !current_user.admin?
        flash[:alert] = "You can edit or delete only your article"
        redirect_to @article
      end
    end
end
