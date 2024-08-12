class CommentsController < ApplicationController

    # GH Codespacesだとドメインがlocalhostではなくなり、CORSエラーになるため、以下の行を追加
    skip_before_action :verify_authenticity_token, if: -> { Rails.env.development? }

    def create
        # 対象となるarticleを取得し、インスタンス化
        @article = Article.find(params[:article_id])
        # 対象articleのcommentとしてformから取得したパラメータを持つcommentをインスタンス化
        @comment = @article.comments.create(comment_params)

        # article_pathヘルパーはArticleのshowアクションを呼び出してくれる
        redirect_to article_path(@article)
    end

    def destroy
        @article = Article.find(params[:article_id])
        @comment = @article.comments.find(params[:id])
        @comment.destroy
        redirect_to article_path(@article), status: :see_other
    end
    
    private
        def comment_params
            params.require(:comment).permit(:commenter, :body, :status)
        end
end
