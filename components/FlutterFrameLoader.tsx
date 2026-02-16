"use client";

import dynamic from "next/dynamic";

const FlutterFrame = dynamic(
  () => import("@/components/FlutterFrame").then((m) => m.FlutterFrame),
  {
    ssr: false,
    loading: () => (
      <div
        style={{
          height: "100vh",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          background: "var(--bg)",
          color: "var(--muted)",
        }}
      >
        Loading…
      </div>
    ),
  }
);

export function FlutterFrameLoader({ route }: { route: string }) {
  return <FlutterFrame route={route} />;
}
