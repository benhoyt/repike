#!/usr/bin/env bash

set -e

# Download a copy of the KJV Bible from Gutenberg (4.3MB of text)
# and repeat it 100x so it's big enough to test with.
if [ ! -f pg10_x100.txt ]; then
	curl -o pg10.txt https://www.gutenberg.org/cache/epub/10/pg10.txt
	cat pg10.txt pg10.txt pg10.txt pg10.txt pg10.txt pg10.txt pg10.txt pg10.txt pg10.txt pg10.txt >pg10_x10.txt
	cat pg10_x10.txt pg10_x10.txt pg10_x10.txt pg10_x10.txt pg10_x10.txt pg10_x10.txt pg10_x10.txt pg10_x10.txt pg10_x10.txt pg10_x10.txt >pg10_x100.txt
fi

# Build C and Go matchers.
gcc -O2 cmd/matchc/match.c -o matchc
go build ./cmd/matchgo
go build ./cmd/matchgoregexp

# Time them all.
export TIMEFORMAT='%R'

echo Grep
time grep 'Ben.*H' <pg10_x100.txt >out.txt
time grep 'Ben.*H' <pg10_x100.txt >out.txt
time grep 'Ben.*H' <pg10_x100.txt >out.txt
time grep 'Ben.*H' <pg10_x100.txt >out.txt
time grep 'Ben.*H' <pg10_x100.txt >out.txt

echo
echo C matcher
time ./matchc 'Ben.*H' <pg10_x100.txt >out.txt
time ./matchc 'Ben.*H' <pg10_x100.txt >out.txt
time ./matchc 'Ben.*H' <pg10_x100.txt >out.txt
time ./matchc 'Ben.*H' <pg10_x100.txt >out.txt
time ./matchc 'Ben.*H' <pg10_x100.txt >out.txt

echo
echo Go matcher
time ./matchgo 'Ben.*H' <pg10_x100.txt >out.txt
time ./matchgo 'Ben.*H' <pg10_x100.txt >out.txt
time ./matchgo 'Ben.*H' <pg10_x100.txt >out.txt
time ./matchgo 'Ben.*H' <pg10_x100.txt >out.txt
time ./matchgo 'Ben.*H' <pg10_x100.txt >out.txt

echo
echo Go regexp
time ./matchgoregexp 'Ben.*H' <pg10_x100.txt >out.txt
time ./matchgoregexp 'Ben.*H' <pg10_x100.txt >out.txt
time ./matchgoregexp 'Ben.*H' <pg10_x100.txt >out.txt
time ./matchgoregexp 'Ben.*H' <pg10_x100.txt >out.txt
time ./matchgoregexp 'Ben.*H' <pg10_x100.txt >out.txt
