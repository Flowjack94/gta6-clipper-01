#!/bin/sh
# Reproduce clip.mp4 from Rockstar's GTA VI Trailer 2.
#
# Source: https://www.youtube.com/watch?v=VQRLujxTm3c
# ("Grand Theft Auto VI Trailer 2", 2:47, Rockstar Games).
#
# Moment chosen: the trailer's last 30 seconds (t=136-166) — jet-ski and
# motorcycle stunts, the sunset highway chase, and the GTA VI logo reveal
# (May 26, 2026). It is the trailer's payoff: the highest-energy run of
# shots, ending on the logo people screenshot and share.
#
# Cut: the first 19 s are centre-cropped to 9:16 vertical; the logo tail
# (last 11 s) is letterboxed so the whole logo stays visible. Overlays:
# "GTA 6 IS COMING" hook (0-3 s), a small "make.fun" watermark throughout,
# and the make.fun pitch in the last 6 s (ghost logo + "MY AI AGENT MADE
# THIS CLIP / AI AGENTS EARN MONEY / MAKING CLIPS ON MAKE.FUN").
#
# Needs: ffmpeg with libx264 + drawtext. The font is bundled in assets/.
# Input is the 30 s source segment in assets/ (already t=136-166 of the
# trailer), so the two inputs below are its 0-19 s and 19-30 s slices.
set -eu
cd "$(dirname "$0")"
ffmpeg -y \
  -ss 0 -t 19 -i assets/source-136-166.mp4 \
  -ss 19 -t 11 -i assets/source-136-166.mp4 \
  -i assets/ghost.png \
  -filter_complex "[0:v]crop=607:1080:(in_w-607)/2:0,scale=1080:1920,setsar=1[va];[1:v]scale=1080:608,pad=1080:1920:0:656:black,setsar=1[vb];[va][vb]concat=n=2:v=1:a=0[vcat];[2:v]scale=170:170[gh];[vcat]drawtext=fontfile=assets/DejaVuSans-Bold.ttf:text='GTA 6 IS COMING':fontsize=92:fontcolor=white:borderw=4:bordercolor=black:x=(w-text_w)/2:y=780:enable='between(t,0,3)'[v1];[v1]drawtext=fontfile=assets/DejaVuSans-Bold.ttf:text='make.fun':fontsize=40:fontcolor=white@0.65:x=w-text_w-36:y=36[v2];[v2][gh]overlay=x=(W-170)/2:y=1300:enable='between(t,24,30)'[v3];[v3]drawtext=fontfile=assets/DejaVuSans-Bold.ttf:text='MY AI AGENT MADE THIS CLIP':fontsize=56:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=1490:enable='between(t,24,30)'[v4];[v4]drawtext=fontfile=assets/DejaVuSans-Bold.ttf:text='AI AGENTS EARN MONEY':fontsize=40:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=1590:enable='between(t,24,30)'[v5];[v5]drawtext=fontfile=assets/DejaVuSans-Bold.ttf:text='MAKING CLIPS ON MAKE.FUN':fontsize=40:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=1670:enable='between(t,24,30)'[vout];[0:a]atrim=0:19,asetpts=PTS-STARTPTS[a0];[1:a]atrim=0:11,asetpts=PTS-STARTPTS[a1];[a0][a1]concat=n=2:v=0:a=1,afade=t=out:st=28:d=2[aout]" \
  -map "[vout]" -map "[aout]" \
  -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p -r 30 \
  -c:a aac -b:a 128k -movflags +faststart clip.mp4
