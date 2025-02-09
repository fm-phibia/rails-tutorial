# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# Rails tutorial
こちらを実施していく
https://guides.rubyonrails.org/getting_started.html

## version

```bash
rails --version
# Rails 7.1.3.4
```

## tutorial

### 4.2 Say "Hello", Rails
以下の項目が必要になる
- route
  - Controllerアクションへリクエストをマッピングするためのもの
- controller
  - リクエストを処理するのに必要な作業の準備
  - Viewに必要なデータの準備
- view
  - rubyとhtmlを混合させたViewのこと

1. リクエストをマッピングするRouteを定義する
2. Routeで定義したContollerを作成するためにコントーラー生成コマンドを実行する

```bash
bin/rails generate controller Articles index --skip-routes
```
※ アクションで明示的にレンダリングするビューを指定しない場合、 Railsは自動的に名前に合致するViewをレンダリングします。
今回の場合は、`app/views/articlesのindex.html.erb`です。

3. `app/views/articles/index.html.erb`の修正

### 5 Autoloading
Railsは`import`や`require`などを利用して他のコードを呼び出す処理を記述する必要がない。
ただし、以下の2ケースにおいては`require`が必要。
- `lib`ディレクトリ下でファイルをロードする場合
- `Gemfile`内で`require: false`を設定してGemの依存関係をロードした場合  

### 6.1 Generating a Model
Railsでは、*Active Record*という機能により、ModelはアプリケーションのDBとやりとりすることができる。

modelの生成には以下のコマンドを実行すればよい。

```bash
bin/rails generate model Article title:string body:text
```

※Modelの名前は単数形にします。理由はModel自体が1つのものを指すからです。

### 6.2 Database Migrations
マイグレーションはアプリのDBの構造を変更するために利用されます。
Railsでは、DBに依存しないためにマイグレーションの処理はRubyで記述されます。
例）`db/migrate/20240809074911_create_articles.rb`

#### Migrateファイルの見方

```rb
class CreateArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
```

`create_table`により、`articles`テーブルが作成されます。`create_table`ではデフォルトとして、オートインクリメントのID列が主キーとして設定されます。
titleやtextはModelを生成するコマンド内で指定したカラムであり、migrateファイルにも記載されています。
t.timestampsは`created_at`と`updated_at`を自動的に追加してくれる項目になります。

#### Migrateの実行
以下のコマンドを実行してマイグレーションを行います。

```bash
bin/rails db:migrate
```

### 6.3 Using a Model to Interact with the Database
Railsには、Modelを操作する機能として`console`というものがあります。
これは対話形式のコーディング環境であり、Railsやアプリケーションコードが自動的に読み込まれます。

```bash
bin/rails console
```

コンソールが起動するので、その中で、以下のコマンドを実行すると、レコードがインサートされます。

```bash
article = Article.new(title: "Hello Rails", body: "I am on Rails!")
# =>
# #<Article:0x00007661080911b0

article.save
#   TRANSACTION (0.1ms)  begin transaction
#  Article Create (1.5ms)  INSERT INTO "articles" ("title", "body", "created_at", "updated_at") VALUES (?, ?, ?, ?) RETURNING "id"  [["title", "Hello Rails"], ["body", "I am on Rails!"], ["created_at", "2024-08-09 08:10:36.029861"], ["updated_at", "2024-08-09 08:10:36.029861"]]
#  TRANSACTION (0.2ms)  commit transaction
# => true 
```

さらにこのコンソールで、以下のコマンドを実行するとDBのarticlesテーブルに対して、IDが1であるレコードを取得してくれます。SELECT文が発行されるような感じです。

```bash
Article.find(1)
```

また、SELECTで指定なしでテーブルの中身を全て取得する場合は、以下のコマンドになります。
この戻り値の型は「ActiveRecord::Relation」という強力な配列になっています。

```bash
Article.all
```

### 6.4 Showing a List of Articles
アプリケーション側からDBの値を取得し、利用していきます。

Railsでは、コントローラーで「＠」を頭につけた変数をViewで利用することができます。
前回の項の内容も踏まえると、以下のように実装することで、Articlesテーブルから取得した全件をViewに渡すことが可能になります。

```rb
@articles = Article.all
```

#### ERBタグ
RailsのViewではHTMLタグの他にERBタグというものを実装できる。
ERBタグには以下の2つが存在する
- <% %>タグ
  - タグの中にRubyのソースコードを実装することができる
- <%= %>タグ
  - タグの中に実装したRubyのソースコード(変数)をHTMLの文字列として出力することができる

### 7.1 Showing a Single Article

以下のように実装することで、「/articles/[id] 」とすることで、「ArticlesController」のshowに遷移することができるようになる
```rb
get "/articles/:id", to: "articles#show"
```

### 7.2 Resourceful Routing
リソースのコレクションに対する全ての従来のルートをマッピングする`resources`ルートがRailsには存在する。

以下のコマンドを実行すると、ルートを確認できる。

```bash
bin/rails routes
```

`resources`は、URLやpathヘルパーも設定してくれます。
上記のコマンドで表示される"Prefix"の値に"_url"や"_path"を結合したものがヘルパーになる。
例えば、上記コマンドの中に以下の行がある。

| Prefix | Verb | URI Pattern | Controller#Action | 
| --- | --- | --- | --- | 
| edit_article | GET  | /articles/:id/edit(.:format) | articles#edit | 

ここでPrefixのedit_articleに_pathを結合した`edit_article_path`を利用すると、URL Patternにある`/articles/#{article.id}/edit`への遷移するためのヘルパーになる。
したがって、html.erbファイルの中で遷移先に`edit_article_path(article)`と実装するだけで、上記のpathへの遷移とすることができる

※実際の実装側は、`article_path`で`/articles/#{article.id}`へのヘルパーを利用した実装を行なった。

#### link_toヘルパー
link_toはさらに応用的なヘルパーです。
第1引数には「リンクテキスト」、第2引数には「リンク」を記述することができます。
第2引数にはオブジェクトを渡すことができ、その場合、適当なpathヘルパーが呼び出されます。
例えばarticleを渡すと、article_path(article)が代わりに呼び出されるようになります。

また、アクションを配列として、第2引数に渡すことで、Pathヘルパーを呼び出すことができます。

```rb
link_to "編集" [:edit, article]
# link_to "編集" edit_article_path(article) と同等
```

### 7.3 Creating a New Article
DBへレコードを追加するには、コントローラの`new`アクションや`create`アクションが一般的に利用されます。
`new`アクションはインスタンス化するが、保存はしません。
`new`アクションはnew.html.erbをレンダリングします。
new.html.ercはフォームを表示する画面とします。

`create`アクションは、タイトルとボディに値を入れて、インスタンス化します。
その後、articleを保存し、/articles/#{article.id}にリダイレクトするように実装します。
保存に失敗すると、422:unprocessable-entity

redirect_to: 新しくリクエストを行う
render: リクエストはそのまま、ビューのレンダリングだけ行う

#### 7.3.1 Using a Form Builder
フォームを作成するにはRailsのフォームビルダーという機能を利用します。

form_withヘルパーメソッドはフォームビルダーをインスタンス化します。
form_withブロック内で、フォームビルダーでlabelやtext_fieldなどのメソッドを呼び出して、適切なフォーム要素を出力します。

#### 7.3.2 Using Strong Parameters
フォームデータは、ルートパラメータと一緒に`params`ハッシュの中に設置されます。
`create`アクションは、`params[:article][:title]`からarticleのタイトルに、`params[:article][:body]`からarticleの本文にアクセスできます。
セキュリティの観点で、直接`params[:article]`にアクセスすることはできないようになっています。
パラメータをフィルタリングするためのRailsの機能として、Strong Parameterという、強力な型付けのようなものが存在する。

### 7.3.3 Validations and Displaying Error Messages
modelオブジェクトのValidationの設定は、modelクラス内に設定することができます。

```rb
class Article < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
end
```

presenceは必須入力、lengthはその長さを指定することができます。
ここで、ActiveRecordは各テーブルのカラムを自動的に取得することができるため、明示的にtitleやbodyの属性を定義する必要はありません。

また、`full_messages_for`メソッドは引数で指定した属性のユーザフレンドリーなエラーメッセージの配列を返却します。

## 7.4 Updating an Article
大体Createと同じ処理になる
### 7.4.1 Using Partials to Share View Code
部分的に共有できるビューを作成する。
共有ビューは、`_form.html.erb`のように`_`始まりのページ名にします。
これを呼び出すには、呼び出し元で以下のように実装します。ここで、`_`が不要になることに注意します。

```rb
<%= render "form", article: @article %>
```

## 7.5 Deleting an Article
以下のようにdataオプションにTurboという属性を付与できます。
`turbo_method`ではリクエスト種別をDELETEにし、
`turbo_confirm`ではリクエスト前にダイアログを表示します。
そのダイアログで「キャンセル」が選択されると、リクエストは実行されません。
```rb
<%= link_to "Destroy", article_path(@article), data: {
                    turbo_method: :delete,
                    turbo_confirm: "Are you sure?"
                  } %>
```

##
以下のようにモデル生成時に`{他のモデル名}:references`をつけると、`{他モデル名}`のIDを外部キーとして保持するカラムが生成したモデルに付与されます。

```bash
bin/rails generate model Comment commenter:string body:text article:references
```

この場合`t.references`型の`article`というカラムが追加され、これは、`article`モデルのIDを外部キーとして設定されるということです。
さらにarticleは複数のcommentを持つことをarticleモデルに宣言しておく必要があります。

## 8.4 Generating a Controller
`show.html.erb`に各articleの内容が表示されるが、その下にコメントを書けるようにしていきます。
form_withヘルパーを使用するが、今回は引数をモデルではなく、配列としています。
配列を利用することで、`/article/1/comment`のようなネストされたルーティングを実現することが可能になります。

## 9.1 Rendering Partial Collections
部分テンプレートを作成して、リファクタしていきます。
`render`で、コレクション（配列など）を渡すと、それを全てループで取り出してレンダリングしてくれます。
今回`@article.comments`を利用しましたが、これは1つ1つのcommentとして取り出されます。
通常、`render`は第1引数で、部分テンプレの名前を指定しますが、今回はコレクション名から対象が[comment]であることが、認識できるため、部分テンプレ名の指定を省略できています。

## 9.2 Rendering a Partial Form
同様にcommentのフォームも部分テンプレ化していきます。
articlesにもcommentsにも`_form.html.erb`が存在していますが、articlesの中のViewからcommentsの方の`_form`を呼び出す際は、`comments/form`と、ディレクトリパスを指定する必要があります。

また、`@article`はコントローラーにおいて、インスタンス化されているため、`comments/_form.html.erb`で直接参照することが可能になります。

## 9.3 Using Concerns
`Concerns`とは、巨大になったControllerや Modelを理解・管理しやすくする機能です。

### Modelへのカラム追加
以下のコマンドで、Articleにstatusというカラムを追加できます。
```bash
bin/rails generate migration AddStatusToArticles status:string
```

### Concernの実装
さて、この状態では、articleもcommentもarchivedだと表示されない、という処理が重複してしまいます。
Concernはこういった**重複した関心事**を切り出す機能になります。

Validationを切り出す場合、Validation自体がクラス単位で呼び出されるメソッドであるため、実装がやや複雑になります。
そのため、Concernは`ActiveSupport::Concern`を継承することで、実装を簡単にしていきます。

## 11.1 Basic Authentication
ユーザが認証していない場合、アクセスを拒否する設定をすることができる。
`http_basic_authenticate_with`メソッドを設定します。
