import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // get bold => null;

  @override
  void initState() {

    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => widget.child!),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset("assets/start.json"),
          Text("Get ready for your trip",
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    ));
  }
}
