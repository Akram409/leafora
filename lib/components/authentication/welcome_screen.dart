import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafora/components/authentication/login_screen.dart';
import 'package:leafora/components/authentication/signup_screen.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Lottie.asset("assets/images/welcome.json",
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.width * 0.7),
              Center(
                child: Image.asset(
                  'assets/images/lefora.png',
                  height: MediaQuery.sizeOf(context).width * 0.3,
                  width: MediaQuery.sizeOf(context).width * 0.3,
                ),
              ),
              SizedBox(height: 10,),
              Center(
                child: Text(
                  "Welcome to Lefora!",
                  style: GoogleFonts.lobster(
                    fontSize: 27,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                    letterSpacing: 2
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Get.offAll(() => SignupScreen());
                },
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 2,color: Colors.green),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child:  Center(
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.aBeeZee(
                        color: Colors.green,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Get.offAll(() => LoginScreen());
                },
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 2,color: Colors.green),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child:  Center(
                    child: Text(
                      'Login',
                      style: GoogleFonts.aBeeZee(
                        color: Colors.green,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
