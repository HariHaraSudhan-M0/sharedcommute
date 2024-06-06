import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sharedcommute/pages/Homepage.dart';

class TripSplashScreen extends StatefulWidget {
  final String splashText;
  const TripSplashScreen({super.key,required this.splashText});

  @override
  State<TripSplashScreen> createState() => _TripSplashScreenState();
}

class _TripSplashScreenState extends State<TripSplashScreen> {
  // get bold => null;

  @override
  void initState() {

    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
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
          LottieBuilder.asset("assets/travel.json"),
          Text(widget.splashText,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    ));
  }
}
