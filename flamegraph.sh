#!/bin/bash

# Profile nnetwork for 30s and generate a flamegraph
DURATION=30
OUTDIR=perf-out
BINARY=./nnetwork   # change if needed

mkdir -p "$OUTDIR"

make clean
make

echo "[*] Starting perf record..."
sudo timeout 30 perf record -F 99 -g --call-graph fp -o $OUTDIR/perf.data $BINARY

echo "[*] Generating folded stacks..."
perf script -i "$OUTDIR/perf.data" | FlameGraph/stackcollapse-perf.pl > "$OUTDIR/out.folded"

echo "[*] Generating flamegraph..."
FlameGraph/flamegraph.pl "$OUTDIR/out.folded" > "$OUTDIR/flamegraph.svg"

echo "[*] Done! Open $OUTDIR/flamegraph.svg in your browser."

