## 概要
Sinatraで作成したシンプルなメモアプリです。
メモを作成、編集、削除、一覧で表示する機能があります。
## 手順
### cloneする
`git clone`を実行してローカルに複製する
```
% git clone https://github.com/siroemk/memo_app
```
`memo_app`ディレクトリに移動する
```
% cd memo_app
```
`bundle install`を実行し、必要なGemをインストールする
```
% bundle install
```

### 手元で保存用のテーブルを作成する
PostgreSQLで自分のアカウントにログインする
```
$ psql -U アカウント名
```
`memos`というデータベースを作成する
```
アカウント名=# CREATE DATABASE memos;
```
¥qでpsql を終了する
```
アカウント名e=# \q
```
memosに接続する
```
$ psql -U アカウント名 memos
```
テーブルを作成する
```
CREATE TABLE t_memos
(id  serial NOT NULL,
title text NOT NULL,
content text NOT NULL,
PRIMARY KEY (id));
```

### 実行する
`app.rb`を実行する
```
% ruby app.rb
```
ブラウザで`http://localhost:4567`にアクセスして表示を確認する
