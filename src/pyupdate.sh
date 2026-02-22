#!/usr/bin/env bash

pyv="3.10 3.11 3.12 3.13 3.14"

for i in $pyv; do
    echo "=>$i"
    python$i -m pip install -U --user --break-system-packages $*
done
