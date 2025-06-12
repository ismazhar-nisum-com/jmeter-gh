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


