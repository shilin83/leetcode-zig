#!/usr/bin/env bash

set -e

if ! command -v kcov; then
    brew install kcov
fi

ERRS=$(zig build test --summary all)

if [ -n "${ERRS}" ]; then
    exit 1
fi

kcov --exclude-pattern=lib coverage .zig-cache/o/*/test

if [ -d coverage ]; then
    open coverage/test/index.html
fi
