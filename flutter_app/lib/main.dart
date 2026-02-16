import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kFakeUserKey = 'flunext_fake_username';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(App(prefs: prefs));
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

/// Fake auth state persisted via SharedPreferences (localStorage on web).
/// Lets you verify that state persists when opening OTC vs Marketplace in separate iframes.
class FakeAuth extends ChangeNotifier {
  FakeAuth(this._prefs) {
    _username = _prefs.getString(_kFakeUserKey);
  }

  final SharedPreferences _prefs;
  String? _username;

  String? get username => _username;
  bool get isLoggedIn => _username != null && _username!.isNotEmpty;

  Future<void> login(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    await _prefs.setString(_kFakeUserKey, trimmed);
    _username = trimmed;
    notifyListeners();
  }

  Future<void> logout() async {
    await _prefs.remove(_kFakeUserKey);
    _username = null;
    notifyListeners();
  }
}

class App extends StatelessWidget {
  const App({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FakeAuth(prefs),
      child: MaterialApp.router(
        title: 'Flunext App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter app (embedded)')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Consumer<FakeAuth>(
              builder: (context, auth, _) {
                if (auth.isLoggedIn) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Logged in as: ${auth.username}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'State is persisted (SharedPreferences / localStorage on web).',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton(
                        onPressed: () => auth.logout(),
                        child: const Text('Log out'),
                      ),
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => context.go('/otc'),
                        child: const Text('Go to OTC'),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () => context.go('/marketplace'),
                        child: const Text('Go to Marketplace'),
                      ),
                    ],
                  );
                }
                return _LoginForm();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Fake login (persisted state check)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Enter a name and log in. Then open OTC or Marketplace from the Next.js links — you should see the same user on the other page.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _controller,
          focusNode: _focus,
          decoration: const InputDecoration(
            labelText: 'Username',
            hintText: 'e.g. test_user',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _submit,
          child: const Text('Log in'),
        ),
      ],
    );
  }

  void _submit() {
    context.read<FakeAuth>().login(_controller.text);
  }
}

class OtcScreen extends StatelessWidget {
  const OtcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTC'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => context.go('/'),
          tooltip: 'Home (Fake login)',
        ),
        actions: [
          Consumer<FakeAuth>(
            builder: (context, auth, _) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: auth.isLoggedIn
                    ? Text(
                        'Logged in as: ${auth.username}',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    : Text(
                        'Not logged in',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('OTC — Flutter screen.'),
            const SizedBox(height: 8),
            Consumer<FakeAuth>(
              builder: (context, auth, _) => Text(
                auth.isLoggedIn
                    ? 'State persisted: you are still "${auth.username}" here.'
                    : 'Use Fake login on Home to test state persistence.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => context.go('/'),
          tooltip: 'Home (Fake login)',
        ),
        actions: [
          Consumer<FakeAuth>(
            builder: (context, auth, _) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: auth.isLoggedIn
                    ? Text(
                        'Logged in as: ${auth.username}',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    : Text(
                        'Not logged in',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Marketplace — Flutter screen.'),
            const SizedBox(height: 8),
            Consumer<FakeAuth>(
              builder: (context, auth, _) => Text(
                auth.isLoggedIn
                    ? 'State persisted: you are still "${auth.username}" here.'
                    : 'Use Fake login on Home to test state persistence.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
