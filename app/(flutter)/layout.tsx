import Link from "next/link";

export default function FlutterLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div style={{ minHeight: "100vh", display: "flex", flexDirection: "column" }}>
      <header
        style={{
          padding: "0.75rem 1rem",
          background: "var(--surface)",
          borderBottom: "1px solid rgba(255,255,255,0.06)",
          display: "flex",
          alignItems: "center",
          gap: "1rem",
        }}
      >
        <Link
          href="/"
          style={{
            color: "var(--muted)",
            fontSize: "0.875rem",
            fontWeight: 500,
          }}
        >
          ← Back to home
        </Link>
      </header>
      <main style={{ flex: 1 }}>{children}</main>
    </div>
  );
}
