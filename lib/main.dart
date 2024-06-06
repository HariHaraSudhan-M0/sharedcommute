import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:sharedcommute/features/splash_screen/splashscreen.dart';
import 'package:sharedcommute/features/splash_screen/tripPostedScreen.dart';
import 'package:sharedcommute/pages/Homepage.dart';
import 'package:sharedcommute/pages/LoginPage.dart';
import 'package:sharedcommute/pages/SignUpPage.dart';
import 'package:sharedcommute/pages/owner/owner_onboard.dart';
import 'package:sharedcommute/pages/owner/post/a-postingPage.dart';
import 'package:sharedcommute/pages/owner/post/b-posting_start_selector.dart';
import 'package:sharedcommute/pages/passenger/trip_list_page.dart';
import 'firebase_options.dart';
// ignore: depend_on_referenced_packages

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
User? user = FirebaseAuth.instance.currentUser;
if (user != null){
  // ignore: avoid_print
  print(user.email);
}
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      routes: {
        '/': (context) =>  SplashScreen(
          // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
          
          child: (user != null)  ? const HomePage(): const LoginPage(),
        ),
        '/login': (context) => const LoginPage(),
        '/signUp': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/ownerPostPage': (context) =>  OwnerOnboard(),
        '/tripList': (context) => TripListPage(),
      },
    );
  }
}



