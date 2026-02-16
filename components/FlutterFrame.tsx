"use client";

import { useEffect, useState } from "react";

/** Next.js does not serve index.html for folder paths in public - use explicit file path */
const FLUTTER_APP_ENTRY = "/flutter-app/index.html";

type FlutterFrameProps = {
  /** Route inside the Flutter app (e.g. "otc", "marketplace"). Maps to hash: #/otc */
  route: string;
  /** Optional: show a loading state until iframe has loaded */
  showLoading?: boolean;
};

export function FlutterFrame({ route, showLoading = true }: FlutterFrameProps) {
  const [loading, setLoading] = useState(showLoading);
  const iframeSrc = `${FLUTTER_APP_ENTRY}#/${route}`;

  useEffect(() => {
    if (!showLoading) return;
    const t = setTimeout(() => setLoading(false), 2500);
    return () => clearTimeout(t);
  }, [showLoading]);

  return (
    <div style={{ position: "relative", width: "100%", height: "100vh" }}>
      {loading && (
        <div
          style={{
            position: "absolute",
            inset: 0,
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            justifyContent: "center",
            background: "var(--bg)",
            zIndex: 1,
            gap: "1rem",
          }}
        >
          <div
            style={{
              width: 40,
              height: 40,
              border: "3px solid var(--surface)",
              borderTopColor: "var(--accent)",
              borderRadius: "50%",
              animation: "spin 0.8s linear infinite",
            }}
          />
          <span style={{ color: "var(--muted)", fontSize: "0.875rem" }}>
            Loading Flutter app…
          </span>
        </div>
      )}
      <iframe
        src={iframeSrc}
        title="Flutter app"
        style={{
          position: "absolute",
          inset: 0,
          width: "100%",
          height: "100%",
          border: "none",
        }}
        onLoad={() => setLoading(false)}
      />
    </div>
  );
}
