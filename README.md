# Gauche-refj-isearch

![image](image.png)

## 概要
- Gauche の開発最新版のソースから、インクリメンタルサーチ機能付きの  
  リファレンスマニュアル(HTMLファイル)を生成するツールです。  
  実行には、ビルドのための開発環境が必要です。


## 実行手順
1. 開発環境のインストール  
   事前に開発環境のインストールが必要です。  
   Windows の場合は、MinGW (32bit) または MSYS2/MinGW-w64 (64bit/32bit) の開発環境が必要です。  
   以下のページを参考にインストールを実施ください。  
   ＜MinGW (32bit) の場合＞  
   https://gist.github.com/Hamayama/362f2eb14ae26d971ca4  
   ＜MSYS2/MinGW-w64 (64bit/32bit) の場合＞  
   http://practical-scheme.net/wiliki/wiliki.cgi?Gauche%3AWindows%2FMinGW-w64  
   (すでにインストール済みであれば本手順は不要です)

2. Gauche のソースのダウンロード  
   Gauche の GitHub のページ  
   https://github.com/shirok/Gauche  
   から、Download Zip ボタン等で開発最新版のソースをダウンロードしてください。  
   そして適当な作業用フォルダ( c:\work 等)に展開してください。  
   (注意) 作業用フォルダのパスには、空白を入れないようにしてください。

3. 本ツールのファイルのコピー  
   本サイト( https://github.com/Hamayama/Gauche-refj-isearch )のファイルを、  
   (Download Zip ボタン等で)ダウンロードして、適当なフォルダに展開してください。  
   そして中のファイル一式を、Gauche のソースの doc フォルダ内にコピーしてください。

4. 本ツールの実行  
   Gauche のソースの doc フォルダ内にコピーしたファイルを実行します。  
   Windows の場合は、MinGW (32bit) 環境であれば、1000_makehtml_isearch_msys.bat を、  
   MSYS2/MinGW-w64 (64bit/32bit) 環境であれば、1000_makehtml_isearch_msys2.bat を、  
   ダブルクリック等で実行してください。  
   他のOSであれば、シェル上で、1001_makehtml_isearch.sh を実行してください。  
   成功すると、以下のファイルが doc フォルダ内に生成されます。
   ```
   gauche-refe-isearch.html  英語版リファレンスマニュアル(インクリメンタルサーチ機能あり)
   gauche-refe-normal.html   英語版リファレンスマニュアル(インクリメンタルサーチ機能なし)
   gauche-refj-isearch.html  日本語版リファレンスマニュアル(インクリメンタルサーチ機能あり)
   gauche-refj-normal.html   日本語版リファレンスマニュアル(インクリメンタルサーチ機能なし)
   ```


## 使い方
- 生成されたHTMLファイルを、ブラウザで開くと、マニュアルを閲覧できます。  
  インクリメンタルサーチ機能ありの場合は、少し待つと左側に検索エリアが表示されます。
- テキストボックスに文字を入力すると、検索結果が表示されます。  
  そして、検索結果をクリックすると、右側に説明が表示されます。  
  また、入力中にEnterキーを押すと、一番上の検索結果の説明を表示します。  
- また、テキストボックスに文字を入力する際に、先頭に半角スペースを入力すると、  
  その次の文字から始まる検索結果だけを表示します。  
  また、末尾に半角スペースを入力すると、その前の文字で終了する検索結果だけを表示します。


## その他、注意事項等
1. マニュアル全体がひとつのファイルになっているため、開くまでに時間がかかります。  
   現状、HTMLファイルの分割には未対応です。

2. 古いブラウザ(IE8等)では、インクリメンタルサーチ機能は使用できません。  
   (その場合は、検索エリアが非表示になります)


## 参考情報
1. インクリメンタルサーチ対応 Gauche ユーザリファレンス  
   http://www.callcc.net/gauche/refj/  
   (ユーザーインターフェースと索引の検索方法を参考にしました)


## 環境等
- OS
  - Windows 8.1 (64bit)
- 環境
  - MinGW (32bit) (makeinfo v4.13)
  - MSYS2/MinGW-w64 (64bit/32bit) (texi2any v6.0, texi2html v1.82)
- 言語
  - Gauche v0.9.5_pre1
- ブラウザ
  - Chrome v48

## 履歴
- 2016-2-16  v1.00 (初版)


(2016-2-16)
