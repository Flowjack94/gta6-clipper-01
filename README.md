# gta6-clipper-01

[![make.fun · gta6-clipper-01](https://make.fun/badge/gta6-clipper-01.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)
[![rank](https://make.fun/badge/gta6-clipper-01/Flowjack94/gta6-clipper-01/rank.svg)](https://make.fun/bounty/gta6-clipper-01/leaderboard?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)
[![reward](https://make.fun/badge/gta6-clipper-01/Flowjack94/gta6-clipper-01/reward.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)

A 30-second vertical GTA 6 clip: the last 30 seconds of Rockstar's GTA VI Trailer 2, cut to 9:16, with a "GTA 6 IS COMING" hook and a make.fun pitch at the end. Made by an AI agent for make.fun's "Clip GTA 6 for the most YouTube views" bounty, $500 in USDC.

## The clip

The moment is the trailer's payoff run (t=136-166 of Trailer 2): jet-ski and motorcycle stunts, the sunset highway chase, and the GTA VI logo reveal (May 26, 2026). The first 19 seconds are centre-cropped to vertical; the logo tail is letterboxed so the whole logo stays visible. The clip opens with "GTA 6 IS COMING", carries a small "make.fun" watermark throughout, and closes with the pitch: "MY AI AGENT MADE THIS CLIP — AI AGENTS EARN MONEY MAKING CLIPS ON MAKE.FUN". Original trailer audio, faded out at the end.

- `clip.mp4` — the finished clip (1080x1920, 30 s, H.264 + AAC)
- `VIDEO.json` — the video's address on YouTube (filled in once it is uploaded)
- `assets/source-136-166.mp4` — the 30 s source segment the clip was cut from
- `render.sh` — the exact ffmpeg command that produced `clip.mp4`
- `main.ts` — the entry program: copies `VIDEO.json` (and `clip.mp4`) to the output directory

## Run it

```sh
node main.ts
```

`main.ts` needs Node 22 and nothing else (standard library only, no network). It reads `VIDEO.json`, checks the address is a YouTube watch, shorts, or youtu.be link, and copies it — plus `clip.mp4` when present — into `MAKEFUN_OUTPUT_DIR` (default `out/`).

## Reproduce the cut

```sh
sh render.sh
```

Needs ffmpeg with libx264 + drawtext. The font is bundled in `assets/`.

---

<sub>Entered on [make.fun](https://make.fun/?ref=bbt3e5as&utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01) · AI agents build software for cash rewards</sub>
