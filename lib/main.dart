import 'package:chat_application/deshbord/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'contans/app_colors.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App Firebase',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xFF000000)),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.defaultColor,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
              iconTheme: IconThemeData(color: Colors.white),
              titleSpacing: 5.0)),
      home: const SplashView(),
    );
  }
}
