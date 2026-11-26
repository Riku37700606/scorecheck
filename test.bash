#!/bin/bash
# SPDX-FileCopyrightText: 2026 Riku37700606
# SPDX-License-Identifier: BSD-3-Clause

ng () {
    echo "${1}行目のテスト失敗"
    res=1
}

res=0

### NORMAL INPUT ###

out=$(printf "80\n45\n90\n60\n55\n" | ./scorecheck)
[ "$?" = 0 ] || ng "$LINENO"
echo "$out" | grep -Fqx "count,5" || ng "$LINENO"
echo "$out" | grep -Fqx "average,66.0" || ng "$LINENO"
echo "$out" | grep -Fqx "max,90.0" || ng "$LINENO"
echo "$out" | grep -Fqx "min,45.0" || ng "$LINENO"
echo "$out" | grep -Fqx "threshold,60" || ng "$LINENO"
echo "$out" | grep -Fqx "passed,3" || ng "$LINENO"
echo "$out" | grep -Fqx "failed,2" || ng "$LINENO"
echo "$out" | grep -Fqx "pass_rate,60.0" || ng "$LINENO"

### CUSTOM THRESHOLD ###

out=$(printf "80\n45\n90\n60\n55\n" | ./scorecheck 80)
[ "$?" = 0 ] || ng "$LINENO"
echo "$out" | grep -Fqx "threshold,80" || ng "$LINENO"
echo "$out" | grep -Fqx "passed,2" || ng "$LINENO"
echo "$out" | grep -Fqx "pass_rate,40.0" || ng "$LINENO"

### ALL PASSED ###

out=$(printf "60\n70\n80\n90\n100\n" | ./scorecheck)
[ "$?" = 0 ] || ng "$LINENO"
echo "$out" | grep -Fqx "pass_rate,100.0" || ng "$LINENO"

### ALL FAILED ###

out=$(printf "10\n20\n30\n40\n50\n" | ./scorecheck)
[ "$?" = 0 ] || ng "$LINENO"
echo "$out" | grep -Fqx "pass_rate,0.0" || ng "$LINENO"

### DECIMAL INPUT ###

out=$(printf "70.5\n59.5\n80\n" | ./scorecheck)
[ "$?" = 0 ] || ng "$LINENO"
echo "$out" | grep -Fqx "average,70.0" || ng "$LINENO"
echo "$out" | grep -Fqx "pass_rate,66.7" || ng "$LINENO"

### BOUNDARY VALUES ###

out=$(printf "0\n59\n60\n100\n" | ./scorecheck)
[ "$?" = 0 ] || ng "$LINENO"
echo "$out" | grep -Fqx "min,0.0" || ng "$LINENO"
echo "$out" | grep -Fqx "max,100.0" || ng "$LINENO"
echo "$out" | grep -Fqx "pass_rate,50.0" || ng "$LINENO"

### INVALID INPUT ###

err=$(mktemp) || exit 1
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
