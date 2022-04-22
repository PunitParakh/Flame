import 'package:flame/pages/login.dart';
import 'package:flame/utils/ai_util.dart';
import 'package:flame/utils/animated_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({ Key? key }) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
    PageController pageController = PageController(initialPage: 0);
    bool _islast = false;

    login() async {

      final pref = await SharedPreferences.getInstance();
      pref.setBool('showHome', true);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context)=>const LoginPage()));
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xffFE612C),
                Color(0xffFF872C),
                Color(0xffFFA12C),
              ],
              stops: [
                0.0,
                0.5,
                0.9
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              tileMode: TileMode.repeated),
        ),
        child: PageView(
            controller: pageController,
            onPageChanged: (index){
              setState(() => _islast = index==2);
            },
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Slide(
                  hero: Image.asset("./assets/guy.png"),
                  title: "Heat up your Soul",
                  subtitle:
                      "Get Access to unlimited songs just in one click,listen to your favourite album/singer only on FLAME",
                  onNext: nextPage,
                  login: login,
                  islast: _islast),
              Slide(
                  hero: Image.asset("./assets/girl.png"),
                  title: "No Advertisement",
                  subtitle:
                      "Listen to the uninterupted music anytime,anywhere.Just open it and play it",
                  onNext: nextPage,
                  login: login,
                  islast: _islast),
              Slide(
                  hero: Image.asset("./assets/indian.png"),
                  title: "Voice Assistant",
                  subtitle:
                      "No worries when Alan's there to assist,so just speak and enjoy the beat",
                  onNext: nextPage,
                  login: login,
                  islast: _islast),
            ]),
      ),
    ));
  }

  void nextPage() {
    pageController.nextPage(
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }
}

class Slide extends StatelessWidget {
  final Widget hero;
  final String title;
  final String subtitle;
  final VoidCallback onNext;
  final VoidCallback login;
  final bool islast;

  const Slide(
      {Key? key,
      required this.hero,
      required this.title,
      required this.login,
      required this.subtitle,
      required this.islast,
      required this.onNext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: hero),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                title,
                style: kTitleStyle,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                subtitle,
                style: kSubtitleStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 35,
              ),
              ProgressButton(onNext: onNext, islast: islast, login: login),
            ],
          ),
        ),
        GestureDetector(
          onTap: onNext,
          child: const Text(
            "Skip",
            style: kSubtitleStyle,
          ),
        ),
        const SizedBox(
          height: 4,
        )
      ],
    );
  }
}



class ProgressButton extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback login;
  // ignore: prefer_typing_uninitialized_variables
  final islast;
  const ProgressButton({Key? key, required this.onNext,required this.login, required this.islast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      height: 75,
      child: Stack(children: [
        AnimatedIndicator(
          duration: const Duration(seconds: 10),
          size: 75,
          callback: onNext,
        ),
        Center(
          child: GestureDetector(
            child: Container(
              height: 60,
              width: 60,
              child: Center(
                child: SvgPicture.asset(
                  "assets/arrow.svg",
                  width: 10,
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99), color: const Color.fromARGB(255, 97, 98, 95)),
            ),
            onTap: islast ? login : onNext,
          ),
        )
      ]),
    );
  }
}