import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sweety_cho/pages/splash_screen.dart';
import 'package:sweety_cho/pages/sweety_cho.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent,
  //   statusBarIconBrightness: Brightness.light,
  // ));

  SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sweety Cho Cosmetics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.pink[300],
      ),
      home: SweetyChoPage(),
      //SplashScreen(),
      //  ChangeNotifierProvider(
      //   builder: (context) => homeViewModel,
      //   child: HomeNewPage(),
      // ),
      //SplashScreen(),
    );
  }
}
