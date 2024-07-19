import 'package:chat_application/utils/app_colors.dart';
import 'package:chat_application/deshbord/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          /*   colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xFF000000)), */
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.defaultColor,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
              iconTheme: IconThemeData(color: AppColors.whiteColor),
              titleSpacing: 5.0)),
      home: const SplashView(),
    );
  }
}
