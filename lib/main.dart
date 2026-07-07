import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/di/injection.dart';
import 'core/routing/router.dart';

void main() async {
  // Ensure Flutter engine binding is initialized before async calls
  WidgetsFlutterBinding.ensureInitialized();

  // Retrieve environment target via --dart-define=ENV=dev/qa/prod (default is 'dev')
  const String env = String.fromEnvironment('ENV', defaultValue: 'qa');

  // Load the corresponding environment configuration from assets
  await dotenv.load(fileName: '.env.$env');

  // Configure Dependency Injection (GetIt & Injectable)
  await configureDependencies();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Enterprise Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
