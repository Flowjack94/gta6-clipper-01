import { copyFileSync, existsSync, mkdirSync, readFileSync } from "node:fs";
import { join, resolve } from "node:path";

// Entrypoint for make.fun's gta6-clipper-01 bounty (node22 runtime).
// Reads VIDEO.json, validates that its url is a YouTube video address,
// and copies VIDEO.json and clip.mp4 to the output directory.
// No network, no wall clock, no files outside the repository.
// Prints nothing on success.

const BOT_DIR = process.env.MAKEFUN_BOT_DIR ?? ".";
const OUTPUT_DIR = process.env.MAKEFUN_OUTPUT_DIR ?? "out";

const VIDEO_ID = /^[A-Za-z0-9_-]{11}$/;

function isYouTubeVideoUrl(value: string): boolean {
  let url: URL;
  try {
    url = new URL(value);
  } catch {
    return false;
  }
  const host = url.hostname.toLowerCase();
  if (host === "youtu.be") {
    const id = url.pathname.replace(/^\//, "").split("/")[0] ?? "";
    return VIDEO_ID.test(id);
  }
  if (
    host === "youtube.com" ||
    host === "www.youtube.com" ||
    host === "m.youtube.com"
  ) {
    const shorts = url.pathname.match(/^\/shorts\/([A-Za-z0-9_-]{11})(?:\/|$)/);
    if (shorts) return true;
    if (url.pathname === "/watch") {
      return VIDEO_ID.test(url.searchParams.get("v") ?? "");
    }
  }
  return false;
}

function main(): void {
  const videoPath = resolve(BOT_DIR, "VIDEO.json");
  const clipPath = resolve(BOT_DIR, "clip.mp4");
  if (!existsSync(videoPath)) {
    throw new Error(`VIDEO.json not found at ${videoPath}`);
  }
  if (!existsSync(clipPath)) {
    throw new Error(`clip.mp4 not found at ${clipPath}`);
  }
  const raw = readFileSync(videoPath, "utf8");
  let parsed: unknown;
  try {
    parsed = JSON.parse(raw);
  } catch {
    throw new Error("VIDEO.json is not valid JSON");
  }
  if (typeof parsed !== "object" || parsed === null || Array.isArray(parsed)) {
    throw new Error("VIDEO.json must be a JSON object with a url field");
  }
  const url = (parsed as { url?: unknown }).url;
  if (typeof url !== "string" || !isYouTubeVideoUrl(url)) {
    throw new Error("VIDEO.json url is not a valid YouTube video URL");
  }
  mkdirSync(OUTPUT_DIR, { recursive: true });
  copyFileSync(videoPath, join(OUTPUT_DIR, "VIDEO.json"));
  copyFileSync(clipPath, join(OUTPUT_DIR, "clip.mp4"));
}

try {
  main();
} catch (error) {
  console.error(error instanceof Error ? error.message : String(error));
  process.exit(1);
}
