#!/usr/bin/env bash
# Renders clip.mp4 for make.fun's gta6-clipper-01 bounty.
#
# The clip is the last 30 seconds of Rockstar's GTA VI Trailer 2
# (t=136-166 of 166.7s): a living-room beat, helicopter and jet-ski action,
# a motorbike and a dusk car chase, then the GTA VI logo reveal with
# "May 26, 2026" and the Rockstar mark.
#
# Cut, in this session, to vertical 1080x1920:
#   - 0:00-0:20 action: centre-cropped 9:16, full-bleed.
#   - 0:20-0:30 logo tail: letterboxed (16:9 scaled to 1080 wide, centred
#     on black) so the wide VI logo stays whole.
# On screen: "GTA 6 IS COMING" for the first 3 seconds, a small "make.fun"
# watermark throughout, and a make.fun end pitch (ghost logo + three lines)
# over the last 5 seconds. Original trailer audio, faded out over the
# last 2 seconds.
#
# Deterministic: re-running this script reproduces clip.mp4 byte-identical
# (single-threaded encode, fixed parameters, no timestamps in metadata).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TRAILER="${TRAILER:-$SCRIPT_DIR/../gta6-clipper-01-work/trailer2-1080p.mp4}"
GHOST="${GHOST:-$SCRIPT_DIR/assets/ghost.png}"
OUT="$SCRIPT_DIR/clip.mp4"
FONT="/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"

if [ ! -f "$TRAILER" ]; then
  echo "trailer not found: $TRAILER" >&2
  exit 1
fi
if [ ! -f "$GHOST" ]; then
  echo "ghost logo not found: $GHOST" >&2
  exit 1
fi
if [ ! -f "$FONT" ]; then
  echo "font not found: $FONT" >&2
  exit 1
fi

FILTER=$(cat <<'EOF'
[0:v]setpts=PTS-STARTPTS,split=2[act][lg];
[act]trim=start=0:end=20,setpts=PTS-STARTPTS,crop=608:1080:656:0,scale=1080:1920:flags=lanczos[action];
[lg]trim=start=20:end=30,setpts=PTS-STARTPTS,scale=1080:608:flags=lanczos,pad=1080:1920:0:656:black[logo];
[action][logo]concat=n=2:v=1:a=0[base];
[1:v]scale=150:150:flags=lanczos[ghost];
[base][ghost]overlay=x=465:y=148:enable='between(t,25,30)'[p1];
[p1]drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:text='MY AI AGENT MADE THIS CLIP':fontsize=46:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=330:enable='between(t,25,30)'[p2];
[p2]drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:text='AI AGENTS EARN MONEY':fontsize=46:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=392:enable='between(t,25,30)'[p3];
[p3]drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:text='MAKING CLIPS ON MAKE.FUN':fontsize=46:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=454:enable='between(t,25,30)'[p4];
[p4]drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:text='GTA 6 IS COMING':fontsize=100:fontcolor=white:borderw=4:bordercolor=black:x=(w-text_w)/2:y=700:enable='between(t,0,3)'[p5];
[p5]drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:text='make.fun':fontsize=36:fontcolor=white@0.75:borderw=2:bordercolor=black@0.6:x=40:y=40[vout];
[0:a]asetpts=PTS-STARTPTS,afade=t=out:st=28:d=2[aout]
EOF
)

ffmpeg -hide_banner -v error -y \
  -ss 136 -t 30 -i "$TRAILER" \
  -loop 1 -t 30 -i "$GHOST" \
  -filter_complex "$FILTER" \
  -map "[vout]" -map "[aout]" \
  -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p -r 30 \
  -threads 1 -filter_threads 1 -filter_complex_threads 1 \
  -c:a aac -b:a 128k \
  -map_metadata -1 \
  "$OUT"

echo "wrote $OUT"
