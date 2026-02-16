import Link from "next/link";

export default function HomePage() {
  return (
    <main
      style={{
        minHeight: "100vh",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        padding: "2rem",
        background:
          "radial-gradient(ellipse 80% 60% at 50% -20%, rgba(99, 102, 241, 0.15), transparent)",
      }}
    >
      <h1
        style={{
          fontSize: "clamp(2rem, 5vw, 3rem)",
          fontWeight: 700,
          letterSpacing: "-0.02em",
          marginBottom: "0.5rem",
        }}
      >
        Flunext
      </h1>
      <p
        style={{
          color: "var(--muted)",
          marginBottom: "2.5rem",
          textAlign: "center",
          maxWidth: "420px",
        }}
      >
        Fast Next.js shell. Flutter loads in the background for app features.
      </p>

      <nav
        style={{
          display: "flex",
          gap: "1rem",
          flexWrap: "wrap",
          justifyContent: "center",
        }}
      >
        <Link
          href="/otc"
          style={{
            padding: "0.75rem 1.5rem",
            background: "var(--accent)",
            color: "white",
            borderRadius: "8px",
            fontWeight: 600,
            border: "none",
            cursor: "pointer",
          }}
        >
          OTC
        </Link>
        <Link
          href="/marketplace"
          style={{
            padding: "0.75rem 1.5rem",
            background: "var(--surface)",
            color: "var(--text)",
            borderRadius: "8px",
            fontWeight: 600,
            border: "1px solid rgba(255,255,255,0.1)",
            cursor: "pointer",
          }}
        >
          Marketplace
        </Link>
      </nav>

      <p
        style={{
          marginTop: "3rem",
          fontSize: "0.875rem",
          color: "var(--muted)",
          maxWidth: "360px",
          textAlign: "center",
        }}
      >
        These links open the Flutter app (loaded on demand). Same Flutter code
        runs on web, iOS, Android, and desktop.
      </p>
    </main>
  );
}
