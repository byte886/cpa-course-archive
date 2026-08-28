#!/bin/bash
# Compress a merged .ts file to H.265 MP4 using ffmpeg, then verify.
# Runs in current terminal (iTerm) with live progress — do NOT run in background.
#
# Usage:
#   bash compress.sh <input.ts> <output.mp4> [crf]
#
# Arguments:
#   input.ts   - merged decrypted transport stream
#   output.mp4 - output MP4 path
#   crf        - x265 CRF value (default 30; lower = better quality/larger file)
#
# After encoding, automatically runs ffprobe verification.

set -euo pipefail

INPUT="${1:?Usage: compress.sh <input.ts> <output.mp4> [crf]}"
OUTPUT="${2:?Usage: compress.sh <input.ts> <output.mp4> [crf]}"
CRF="${3:-30}"

if [ ! -f "$INPUT" ]; then
  echo "ERROR: input file not found: $INPUT"
  exit 1
fi

# Detect CPU core count for x265 threading
CORES=$(sysctl -n hw.ncpu 2>/dev/null || nproc 2>/dev/null || echo 8)

echo "=== FFmpeg H.265 Compression ==="
echo "Input:    $INPUT ($(du -h "$INPUT" | cut -f1))"
echo "Output:   $OUTPUT"
echo "CRF:      $CRF"
echo "Cores:    $CORES"
echo ""

ffmpeg -y -i "$INPUT" \
  -map 0:v:0 -map 0:a:0 \
  -c:v libx265 -crf "$CRF" -preset fast \
  -x265-params "pools=${CORES}:frame-threads=4:wpp=1" \
  -c:a aac -b:a 96k \
  -tag:v hvc1 \
  -movflags +faststart \
  "$OUTPUT"

echo ""
echo "=== Compression Complete ==="
ls -lh "$OUTPUT" | awk '{print "Size:", $5}'

# Verify output
echo ""
echo "=== Verification ==="
DURATION_IN=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$INPUT" 2>/dev/null)
DURATION_OUT=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$OUTPUT" 2>/dev/null)
VCODEC=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name,width,height -of default=noprint_wrappers=1 "$OUTPUT" 2>/dev/null)
BITRATE=$(ffprobe -v error -show_entries format=bit_rate -of default=noprint_wrappers=1:nokey=1 "$OUTPUT" 2>/dev/null)

echo "Input duration:  ${DURATION_IN}s"
echo "Output duration: ${DURATION_OUT}s"
echo "Video: $VCODEC"
echo "Bitrate: $((BITRATE / 1000)) kbps"

# Check duration difference (allow 2s tolerance)
DUR_DIFF=$(echo "$DURATION_IN - $DURATION_OUT" | bc 2>/dev/null || echo "999")
DUR_DIFF_ABS=$(echo "${DUR_DIFF#-}" | bc 2>/dev/null || echo "999")
if (( $(echo "$DUR_DIFF_ABS < 2" | bc -l) )); then
  echo "✅ Duration matches"
else
  echo "⚠️  Duration mismatch! Input=${DURATION_IN}s Output=${DURATION_OUT}s"
  exit 1
fi

# Check moov atom (playability)
if ffprobe -v error "$OUTPUT" >/dev/null 2>&1; then
  echo "✅ File is valid and playable"
else
  echo "❌ File is invalid (moov atom missing or corrupt)"
  exit 1
fi
