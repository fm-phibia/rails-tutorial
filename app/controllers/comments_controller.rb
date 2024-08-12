class CommentsController < ApplicationController
    def create
        # 対象となるarticleを取得し、インスタンス化
        @article = Article.find(params[:article_id])
        # 対象articleのcommentとしてformから取得したパラメータを持つcommentをインスタンス化
        @comment = @article.comments.create(comment_params)

        # article_pathヘルパーはArticleのshowアクションを呼び出してくれる
        redirect_to article_path(@article)
    end
    
    private
        def comment_params
            params.require(:comment).permit(:commenter, :body)
        end
end
