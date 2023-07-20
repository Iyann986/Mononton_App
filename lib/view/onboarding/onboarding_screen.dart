import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mononton_app/themes/themes.dart';
import 'package:mononton_app/view/access/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/onboarding_model.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  static const String route = "/onboarding";

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  _storeOnboardingInfo() async {
    // ignore: avoid_print
    print('Shared pref called');
    int isviewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isviewed);
    // ignore: avoid_print
    print(prefs.getInt('onBoard'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentIndex % 1 == 0
          ? Themes.colors.whiteText
          : Themes.colors.blueAppbar,
      appBar: AppBar(
        backgroundColor: currentIndex % 1 == 0
            ? Themes.colors.whiteText
            : Themes.colors.blueAppbar,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              _storeOnboardingInfo();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            child: Text(
              'Skip',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: currentIndex % 1 == 0
                    ? Themes.colors.greyText
                    : Themes.colors.whiteText,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Image.asset(
                        contents[i].img,
                        height: 230,
                      ),
                      const SizedBox(height: 50),
                      Text(
                        contents[i].title,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff1B3A73),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        contents[i].desc,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff717076),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.all(45),
            width: double.infinity,
            child: TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: const BorderSide(
                      color: Color(0xffE21221),
                    ),
                  ),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xffE21221)),
              ),
              child: Text(
                  currentIndex == contents.length - 1 ? "Get Started" : "Next"),
              onPressed: () {
                if (currentIndex == contents.length - 1) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }
                _controller.nextPage(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.bounceIn,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names, avoid_types_as_parameter_names
  Container buildDot(int index, BuildContext) {
    return Container(
      height: 10,
      width: currentIndex == index ? 40 : 13,
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: currentIndex == index
            ? Themes.colors.redText
            : Themes.colors.greyText,
      ),
    );
  }
}
