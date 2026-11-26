#!/bin/bash

ng () {
    echo "${1}行目のテスト失敗"
    res=1
}

res=0

### NORMAL INPUT ###

out=$(printf "80\n45\n90\n60\n55\n" | ./scorecheck)
[ "$?" = 0 ] || ng "$LINENO"
echo "$out" | grep -qx "受験者数: 5人" || ng "$LINENO"
echo "$out" | grep -qx "平均点: 66.0点" || ng "$LINENO"
echo "$out" | grep -qx "最高点: 90.0点" || ng "$LINENO"
echo "$out" | grep -qx "最低点: 45.0点" || ng "$LINENO"
echo "$out" | grep -qx "合格基準: 60点" || ng "$LINENO"
echo "$out" | grep -qx "合格者数: 3人" || ng "$LINENO"
echo "$out" | grep -qx "不合格者数: 2人" || ng "$LINENO"
echo "$out" | grep -qx "合格率: 60.0%" || ng "$LINENO"

### CUSTOM THRESHOLD ###

out=$(printf "80\n45\n90\n60\n55\n" | ./scorecheck 80)
[ "$?" = 0 ] || ng "$LINENO"
echo "$out" | grep -qx "合格基準: 80点" || ng "$LINENO"
echo "$out" | grep -qx "合格者数: 2人" || ng "$LINENO"
echo "$out" | grep -qx "合格率: 40.0%" || ng "$LINENO"

### ALL PASSED ###

out=$(printf "60\n70\n80\n90\n100\n" | ./scorecheck)
[ "$?" = 0 ] || ng "$LINENO"
echo "$out" | grep -qx "合格率: 100.0%" || ng "$LINENO"

### ALL FAILED ###

out=$(printf "10\n20\n30\n40\n50\n" | ./scorecheck)
[ "$?" = 0 ] || ng "$LINENO"
echo "$out" | grep -qx "合格率: 0.0%" || ng "$LINENO"

### DECIMAL INPUT ###

out=$(printf "70.5\n59.5\n80\n" | ./scorecheck)
[ "$?" = 0 ] || ng "$LINENO"
echo "$out" | grep -qx "平均点: 70.0点" || ng "$LINENO"
echo "$out" | grep -qx "合格率: 66.7%" || ng "$LINENO"

### BOUNDARY VALUES ###

out=$(printf "0\n59\n60\n100\n" | ./scorecheck)
[ "$?" = 0 ] || ng "$LINENO"
echo "$out" | grep -qx "最低点: 0.0点" || ng "$LINENO"
echo "$out" | grep -qx "最高点: 100.0点" || ng "$LINENO"
echo "$out" | grep -qx "合格率: 50.0%" || ng "$LINENO"

### INVALID INPUT ###

err=$(mktemp)
trap 'rm -f "$err"' EXIT

out=$(echo あ | ./scorecheck 2>"$err")
[ "$?" = 1 ] || ng "$LINENO"
[ "$out" = "" ] || ng "$LINENO"
[ -s "$err" ] || ng "$LINENO"

out=$(echo 120 | ./scorecheck 2>"$err")
[ "$?" = 1 ] || ng "$LINENO"
[ "$out" = "" ] || ng "$LINENO"
[ -s "$err" ] || ng "$LINENO"

out=$(echo -10 | ./scorecheck 2>"$err")
[ "$?" = 1 ] || ng "$LINENO"
[ "$out" = "" ] || ng "$LINENO"
[ -s "$err" ] || ng "$LINENO"

out=$(echo | ./scorecheck 2>"$err")
[ "$?" = 1 ] || ng "$LINENO"
[ "$out" = "" ] || ng "$LINENO"
[ -s "$err" ] || ng "$LINENO"

out=$(./scorecheck < /dev/null 2>"$err")
[ "$?" = 1 ] || ng "$LINENO"
[ "$out" = "" ] || ng "$LINENO"
[ -s "$err" ] || ng "$LINENO"

### INVALID ARGUMENTS ###

out=$(echo 80 | ./scorecheck abc 2>"$err")
[ "$?" = 1 ] || ng "$LINENO"
[ "$out" = "" ] || ng "$LINENO"
[ -s "$err" ] || ng "$LINENO"

out=$(echo 80 | ./scorecheck 110 2>"$err")
[ "$?" = 1 ] || ng "$LINENO"
[ "$out" = "" ] || ng "$LINENO"
[ -s "$err" ] || ng "$LINENO"

out=$(echo 80 | ./scorecheck 60 70 2>"$err")
[ "$?" = 1 ] || ng "$LINENO"
[ "$out" = "" ] || ng "$LINENO"
[ -s "$err" ] || ng "$LINENO"

### RESULT ###

[ "$res" = 0 ] && echo OK
exit "$res"
