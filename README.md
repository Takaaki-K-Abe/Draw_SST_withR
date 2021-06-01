# SSTの描写

## 使用データ

- SSTのデータはNOAAのOISSTを使用するが、データのダウンロードは`DrawSST_2019_10.R`を実行すれば開始するようになっている。
- 関数自体は`functions/sst_dl.R`に格納されている

## 使用方法

- `DrawSST_2019_10.R`を実行すれば2019年10月の日本近海のSSTを描写し、`SSTpng`(ディレクトリは自動生成される) に画像を保存するようになっている。
- `creategif.sh`を実行すれば`SSTpng`の画像を読み込んで、`SST.gif`が作成されるが、`imagemagick`が必要なので、事前に`imagemagick`を導入しておくこと
