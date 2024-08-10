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

