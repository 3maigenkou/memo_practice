# メモアプリ
sinatraを使って作成したシンプルなメモアプリです。

## 使い方
### 1.ダウンロード
```
% git clone https://github.com/3maigenkou/memo_practice.git
```
### 2.bundleのインストール
```
% bundle install
```
### 3.PostgreSQLでデータベースの作成
```
% psql -U postgres
# CREATE DATABASE memotest;
# \c memotest
# CREATE TABLE t_memos
  (id  SERIAL,
  title TEXT NOT NULL,
  comment TEXT,
  PRIMARY KEY (id));
# \q
```
### 4.アプリの起動
```
% bundle exec ruby app.rb
```
### 4.ブラウザでアクセス
[http://localhost:4567](http://localhost:4567)
