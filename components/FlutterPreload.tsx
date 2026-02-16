"use client";

import { useEffect } from "react";

/** Next.js does not serve index.html for folder paths - use explicit file path */
const FLUTTER_APP_ENTRY = "/flutter-app/index.html";

/**
 * Invisible iframe that loads the Flutter app in the background.
 * After mount, Flutter engine is cached; when user navigates to /otc or /marketplace,
 * the visible iframe can reuse the same origin and load faster (browser cache).
 */
export function FlutterPreload() {
  useEffect(() => {
    const iframe = document.createElement("iframe");
    iframe.src = FLUTTER_APP_ENTRY;
    iframe.style.cssText =
      "position:absolute;width:0;height:0;border:0;visibility:hidden;pointer-events:none";
    iframe.setAttribute("aria-hidden", "true");
    document.body.appendChild(iframe);
    return () => {
      document.body.removeChild(iframe);
    };
  }, []);

  return null;
}
