import 'package:flutter/material.dart';
import 'package:jaankari/chat_screen.dart';
import 'package:jaankari/home_screen.dart';
import 'package:jaankari/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      child: MaterialApp(
        title: 'Jaankari',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        initialRoute: '/splash',
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => HomeScreen(),
          '/splash': (context) => SplashScreen(),
          '/chat': (context) => ChatScreen(),
        },
        home: ChatScreen(),
      ),
    );
  }
}
