import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const App());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomeScreen(),
    ),
    GoRoute(
      path: '/otc',
      builder: (_, __) => const OtcScreen(),
    ),
    GoRoute(
      path: '/marketplace',
      builder: (_, __) => const MarketplaceScreen(),
    ),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flunext App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1), brightness: Brightness.dark),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Flutter app (embedded)'),
            const SizedBox(height: 16),
            TextButton(onPressed: () => context.go('/otc'), child: const Text('Go to OTC')),
            TextButton(onPressed: () => context.go('/marketplace'), child: const Text('Go to Marketplace')),
          ],
        ),
      ),
    );
  }
}

class OtcScreen extends StatelessWidget {
  const OtcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTC')),
      body: const Center(
        child: Text('OTC — Flutter screen. Same UI on web, iOS, Android, desktop.'),
      ),
    );
  }
}

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace')),
      body: const Center(
        child: Text('Marketplace — Flutter screen. Same UI on web, iOS, Android, desktop.'),
      ),
    );
  }
}
