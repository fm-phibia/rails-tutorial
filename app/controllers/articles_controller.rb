class ArticlesController < ApplicationController

  # GH Codespacesだとドメインがlocalhostではなくなり、CORSエラーになるため、以下の行を追加
  skip_before_action :verify_authenticity_token, if: -> { Rails.env.development? }

  # indexとshowアクション以外ではBasic認証が必要になります。
  http_basic_authenticate_with name: "rails", password: "secret", except: [:index, :show]

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

  def edit
    # GET /articles/:id/edit
    @article = Article.find(params[:id])
  end

  def update
    # PATCH  /articles/:id
    # PUT    /articles/:id
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # DELETE /articles/:id
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, status: :see_other
  end
  private
    def article_params
      params.require(:article).permit(:title, :body, :status)
    end

end
