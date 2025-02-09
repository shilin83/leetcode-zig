#!/usr/bin/env bash

set -e

if [ -d coverage ]; then
	rm -rf coverage
fi

if ! command -v kcov /dev/null 2>&1; then
	brew install kcov
fi

zig build coverage

open coverage/index.html
