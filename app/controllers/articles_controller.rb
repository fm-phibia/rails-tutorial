class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end
  
  def show
    @article = Article.find(params[:id])
  end

  def new
    # 空のarticleインスタンスを生成する
    @article = Article.new
  end

  def create
    ## articles#create
    # POST /articles
    
    # article_paramsでtitleやbodyを取得したarticleインスタンスを生成する
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def article_params
      params.require(:article).permit(:title, :body)
    end

end
