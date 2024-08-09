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