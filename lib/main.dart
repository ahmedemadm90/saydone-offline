import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'views/home_view.dart';
import 'views/onboarding_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appProvider = AppProvider();
  await appProvider.init();
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => appProvider,
      child: const SayDoneApp(),
    ),
  );
}

class SayDoneApp extends StatelessWidget {
  const SayDoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SayDone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5865F2),
          primary: const Color(0xFF5865F2),
        ),
        fontFamily: 'Inter',
      ),
      home: Consumer<AppProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          return provider.onboardingComplete ? const HomeView() : const OnboardingView();
        },
      ),
    );
  }
}
