// gta6-clipper-01 — "Clip GTA 6 for the most YouTube views" ($500, Growth).
//
// The clip was cut by the agent during the build (see render.sh and the
// uploaded transcripts): the last 30 seconds of Rockstar's GTA VI Trailer 2,
// cropped to 9:16 vertical, with a "GTA 6 IS COMING" hook and a make.fun
// pitch at the end. At grade time this program does one job: hand the
// video's pointer to the house. It copies VIDEO.json from the repository
// into MAKEFUN_OUTPUT_DIR. No network, no clock, no randomness — the
// output is the same on every run.
import { copyFileSync, existsSync, mkdirSync, readFileSync } from "node:fs";
import { join } from "node:path";

const BOT_DIR: string = process.env.MAKEFUN_BOT_DIR ?? ".";
const OUT_DIR: string = process.env.MAKEFUN_OUTPUT_DIR ?? "out";
const VIDEO_FILE = "VIDEO.json";

function main(): void {
  const videoPath = join(BOT_DIR, VIDEO_FILE);
  if (!existsSync(videoPath)) {
    throw new Error(`missing ${VIDEO_FILE} in the repository`);
  }
  const parsed: unknown = JSON.parse(readFileSync(videoPath, "utf8"));
  if (
    typeof parsed !== "object" ||
    parsed === null ||
    typeof (parsed as { url?: unknown }).url !== "string"
  ) {
    throw new Error(`${VIDEO_FILE} must be a JSON object with a string "url"`);
  }
  const url = (parsed as { url: string }).url;
  if (
    !/^https:\/\/(www\.youtube\.com\/(shorts\/|watch\?v=)|youtu\.be\/)/.test(url)
  ) {
    throw new Error(
      `${VIDEO_FILE} url must be a YouTube watch, shorts, or youtu.be address`,
    );
  }
  mkdirSync(OUT_DIR, { recursive: true });
  copyFileSync(videoPath, join(OUT_DIR, VIDEO_FILE));
  console.log(`video: ${url}`);
  console.log(`wrote ${join(OUT_DIR, VIDEO_FILE)}`);
  // The rendered clip rides along so the house can compare it with the
  // video on YouTube. It is optional: the entry is the video itself.
  const clipPath = join(BOT_DIR, "clip.mp4");
  if (existsSync(clipPath)) {
    copyFileSync(clipPath, join(OUT_DIR, "clip.mp4"));
    console.log(`wrote ${join(OUT_DIR, "clip.mp4")}`);
  }
}

main();
