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
今回の場合は、`app/views/articlesのindex.html/erb`です。

3. 