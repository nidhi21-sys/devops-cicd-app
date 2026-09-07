#!/bin/bash

echo "Running automated test..."

if grep -q "Jenkins CI/CD Demo" index.html
then
    echo "TEST PASSED"
    exit 0
else
    echo "TEST FAILED"
    exit 1
fi

