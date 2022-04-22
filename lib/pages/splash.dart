import 'package:flame/pages/login.dart';
import 'package:flame/pages/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var showHome;

  @override
  void initState() {
    super.initState();
    onboarding();
    navigatetoHome();
  }

  onboarding() async {
    final pref = await SharedPreferences.getInstance();
    showHome = pref.getBool('showHome') ?? false;
    print(showHome);
  }

  navigatetoHome() async {
    await Future.delayed(const Duration(milliseconds: 3000), () {});
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => showHome ? const LoginPage(): const OnboardingScreen(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(221, 53, 49, 49),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset('assets/fire.json'),
          ),
          Center(
            child: "Fire Up Your Mood!!".text.xl5.bold.white.italic.make().shimmer(
                  primaryColor: Color.fromARGB(255, 232, 10, 10), 
                  secondaryColor: Color.fromARGB(255, 239, 145, 3)),
          )
        ],
      ),
    );
  }
} 


