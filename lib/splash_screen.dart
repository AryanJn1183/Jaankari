import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jaankari/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> offsetAnimation;

  @override
  void dispose() {
    animationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive); // removes appbar and bottom bar

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    animationController.addListener(() {
      setState(() {});
    });

    // offsetAnimation = Tween<Offset>(
    //   begin: const Offset(25, 250),
    //   end: const Offset(33, 250),
    // ).animate(CurvedAnimation(
    //   parent: animationController,
    //   curve: const Interval(0.1, 0.2, curve: Curves.easeInToLinear),
    // ));

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(
              'assets/images/splash_bg.png',
              height: 900.h,
              width: 400.w,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              top: MediaQuery.of(context).size.height * 0.4,
              left: 0,
              right: 0,
              // child: AnimatedBuilder(
              //   animation: animationController,
              //   builder: (context, child) => Transform.translate(
              //     offset: offsetAnimation.value,
              //     child: child,
              //   ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/jaankari_logo.png',
                    width: 234.92.w,
                    height: 52.53.h,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
