# scorecheck

[![test](https://github.com/Riku37700606/scorecheck/actions/workflows/test.yml/badge.svg)](https://github.com/Riku37700606/scorecheck/actions/workflows/test.yml)

テストの点数を集計するためのコマンドです。
複数人の点数から平均点や最高点、最低点、合格率などを求めることができます。
合格基準は引数で変更できます。
集計結果はCSV形式で出力されるため、他のコマンドとの組み合わせやファイルへの保存が可能です。

## 機能

- 受験者数の集計
- 平均点の計算
- 最高点と最低点の取得
- 合格者数と不合格者数の集計
- 合格率の計算
- 合格基準の変更
- CSV形式での出力

## インストール方法

```bash
$ git clone https://github.com/Riku37700606/scorecheck.git
$ cd scorecheck
$ chmod +x scorecheck
```

## 使用方法

### 基本的な使い方

標準入力から1行につき1つの点数を入力します。
点数は0〜100の範囲で、小数にも対応しています。
合格基準の初期値は60点です。

```bash
$ printf "80\n45\n90\n60\n55\n" | ./scorecheck
count,5
average,66.0
max,90.0
min,45.0
threshold,60
passed,3
failed,2
pass_rate,60.0
```

### 合格基準の変更

引数を指定することで合格基準を変更できます。
合格基準も0〜100の範囲で指定します。

```bash
$ printf "80\n45\n90\n60\n55\n" | ./scorecheck 80
count,5
average,66.0
max,90.0
min,45.0
threshold,80
passed,2
failed,3
pass_rate,40.0
```

### ファイルからの入力

```bash
$ printf "80\n45\n90\n60\n55\n" > scores.txt
$ ./scorecheck < scores.txt
count,5
average,66.0
max,90.0
min,45.0
threshold,60
passed,3
failed,2
pass_rate,60.0
```

## 出力項目

| 項目名 | 内容 |
| --- | --- |
| count | 受験者数（人） |
| average | 平均点（点） |
| max | 最高点（点） |
| min | 最低点（点） |
| threshold | 合格基準（点） |
| passed | 合格者数（人） |
| failed | 不合格者数（人） |
| pass_rate | 合格率（%） |

項目名と数値をカンマで区切って出力します。

## 他のコマンドとの連携

### 平均点のみを取得する

```bash
$ printf "80\n45\n90\n60\n55\n" | ./scorecheck | grep '^average,' | cut -d, -f2
66.0
```

### 合格率のみを取得する

```bash
$ printf "80\n45\n90\n60\n55\n" | ./scorecheck | grep '^pass_rate,' | cut -d, -f2
60.0
```

### 集計結果をファイルに保存する

```bash
$ printf "80\n45\n90\n60\n55\n" | ./scorecheck > result.csv
```

## エラー処理

以下の場合はエラーになります。

- 数値以外の点数を入力した場合
- 0〜100の範囲外の点数を入力した場合
- 空行を入力した場合
- 点数が入力されていない場合
- 合格基準が数値でない場合
- 合格基準が0〜100の範囲外の場合
- 引数を2つ以上指定した場合

エラーメッセージは標準エラー出力に表示されます。
正常終了時の終了ステータスは0、異常終了時は1です。

## 必要なソフトウェア

- Python 3
- Bash（テストの実行に使用）

Pythonの外部ライブラリは必要ありません。

## テスト環境

### ローカル環境

- Ubuntu 24.04.5 LTS
- Python 3.12.3

### GitHub Actions

- Ubuntu 24.04
- Python 3.10
- Python 3.11
- Python 3.12
- Python 3.13
- Python 3.14

## テスト方法

```bash
$ bash test.bash
OK
```

## 参考資料・謝辞

テストスクリプトとGitHub Actionsの設定には、
ロボットシステム学2026の講義資料を参考にしました。

- [ロボットシステム学2026 第6回](https://tarolab-cit.github.io/lectures/robosys2026/lecture06.html)
- [ロボットシステム学2026 第7回](https://tarolab-cit.github.io/lectures/robosys2026/lecture07.html)

## ライセンス

このソフトウェアはBSD 3-Clause Licenseの下で公開されています。
詳細は[LICENSE](LICENSE)を参照してください。

## 著作権

© 2026 Riku37700606
