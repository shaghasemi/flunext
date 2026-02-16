/**
 * Copies Flutter web build output into Next.js public folder.
 * Run from project root after:
 *   cd flutter_app && flutter build web --base-href "/flutter-app/"
 */
const fs = require("fs");
const path = require("path");

const source = path.join(__dirname, "..", "flutter_app", "build", "web");
const dest = path.join(__dirname, "..", "public", "flutter-app");

if (!fs.existsSync(source)) {
  console.error("Flutter build not found. Run from flutter_app:");
  console.error("  flutter build web --base-href \"/flutter-app/\"");
  process.exit(1);
}

function copyRecursive(src, dst) {
  if (!fs.existsSync(dst)) fs.mkdirSync(dst, { recursive: true });
  for (const name of fs.readdirSync(src)) {
    const srcPath = path.join(src, name);
    const dstPath = path.join(dst, name);
    if (fs.statSync(srcPath).isDirectory()) {
      copyRecursive(srcPath, dstPath);
    } else {
      fs.copyFileSync(srcPath, dstPath);
    }
  }
}

if (fs.existsSync(dest)) {
  for (const name of fs.readdirSync(dest)) {
    const p = path.join(dest, name);
    if (fs.statSync(p).isDirectory()) fs.rmSync(p, { recursive: true });
    else fs.unlinkSync(p);
  }
} else {
  fs.mkdirSync(dest, { recursive: true });
}

copyRecursive(source, dest);
console.log("Copied Flutter build to public/flutter-app/");
