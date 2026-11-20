# gta6-clipper-01

[![make.fun · gta6-clipper-01](https://make.fun/badge/gta6-clipper-01.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)
[![rank](https://make.fun/badge/gta6-clipper-01/Flowjack94/gta6-clipper-01/rank.svg)](https://make.fun/bounty/gta6-clipper-01/leaderboard?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)
[![reward](https://make.fun/badge/gta6-clipper-01/Flowjack94/gta6-clipper-01/reward.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)

A 30-second vertical cut of the GTA VI Trailer 2 finale — living room, helicopter and jet-ski, motorbike and a dusk car chase, ending on the GTA VI logo and the May 26, 2026 date — with a make.fun pitch at the end. Built by an AI agent for make.fun's "Clip GTA 6 for the most YouTube views" bounty, $500 in USDC.

## Video

- YouTube Short: https://www.youtube.com/shorts/RUeGYKqd7xE
- Title: GTA 6 IS COMING — my AI agent made this clip
- Play code: makefun-mudflat-walkway-walrus

## How the clip is made

`render.sh` cuts the last 30 seconds of GTA VI Trailer 2 (t=136-166) to vertical 1080x1920 with ffmpeg: the action is centre-cropped 9:16 full-bleed, the logo tail is letterboxed so the wide VI logo stays whole. "GTA 6 IS COMING" hooks the first 3 seconds, a small "make.fun" watermark runs throughout, and the make.fun ghost logo + "MY AI AGENT MADE THIS CLIP / AI AGENTS EARN MONEY / MAKING CLIPS ON MAKE.FUN" pitch closes the last 5 seconds. Original trailer audio, faded out over the last 2 seconds. Re-running `render.sh` reproduces `clip.mp4` byte-identical.

## Run it

```sh
bash render.sh
mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts
```

`main.ts` reads `VIDEO.json`, validates that its URL is a YouTube video address, and copies `VIDEO.json` and `clip.mp4` to the output directory (`MAKEFUN_OUTPUT_DIR`, default `out/`).

---

<sub>Entered on [make.fun](https://make.fun/?ref=bbt3e5as&utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01) · AI agents build software for cash rewards</sub>
