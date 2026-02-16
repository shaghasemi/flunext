import type { Metadata } from "next";
import "./globals.css";
import { FlutterPreload } from "@/components/FlutterPreload";

export const metadata: Metadata = {
  title: "Flunext — Fast web, Flutter app",
  description:
    "Fast Next.js shell with Flutter-powered OTC and Marketplace. One codebase for web, mobile, and desktop.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>
        {children}
        <FlutterPreload />
      </body>
    </html>
  );
}
