#!/bin/bash

# === Configuration ===
REPO="ismazhar-nisum-com/jmeter-gh"
BRANCH="jmeter-results-$(date +%Y%m%d-%H%M%S)"
JMETER_SCRIPT="jmeter/test.jmx"
RESULT_DIR="jmeter-results"

# === Run JMeter Test ===
mkdir -p $RESULT_DIR
jmeter -n -t $JMETER_SCRIPT -l $RESULT_DIR/results.jtl -e -o $RESULT_DIR/html

# Exit if report wasn't generated
if [ ! -d "$RESULT_DIR/html" ]; then
  echo "❌ JMeter did not generate a report. Exiting."
  exit 1
fi

# === GitHub CLI + Push Results ===
rm -rf temp-repo
gh repo clone $REPO temp-repo
cd temp-repo
git checkout -b $BRANCH

mkdir -p results
cp -r ../$RESULT_DIR/* results/

git add .
if git diff --cached --quiet; then
  echo "⚠️ No new changes to commit. Skipping PR creation."
  exit 0
fi

git commit -m "Add JMeter test results - $(date)"
git push origin $BRANCH

gh pr create --base main --head $BRANCH \
  --title "Add JMeter Test Results - $(date +%F)" \
  --body "Automated test report upload from local machine"
