import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants.dart';
import '../../widgets/text_input_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  bool webView = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (size.width > 800) {
      webView = true;
    } else {
      webView = false;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: const [0.0, 0.8],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              primaryColor,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.05),
              Text(
                "SOSPAC",
                style: GoogleFonts.ultra(
                  fontSize: 50,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                "Your social space!",
                style: GoogleFonts.poppins(
                  fontSize: 27,
                  color: secondaryColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: primaryColor,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: secondaryColor,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person_rounded,
                          size: 85,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: InkWell(
                      onTap: () => authController.pickImage(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.add_a_photo,
                          size: 30,
                          color: Color(0XFF767676),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                width: webView == false ? size.width * 0.9 : size.width * 0.3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextInputField(
                  controller: _userNameController,
                  labelText: "Username",
                  icon: Icons.person,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                width: webView == false ? size.width * 0.9 : size.width * 0.3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextInputField(
                  controller: _emailController,
                  labelText: "Email",
                  icon: Icons.email,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                width: webView == false ? size.width * 0.9 : size.width * 0.3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextInputField(
                  controller: _passwordController,
                  labelText: "Password",
                  icon: Icons.lock,
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Container(
                height: 50,
                width: webView == false ? size.width * 0.75 : size.width * 0.20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: secondaryColor,
                ),
                child: Center(
                  child: SizedBox(
                    height: 50,
                    width: size.width * 0.75,
                    child: TextButton(
                      onPressed: () => authController.registerUser(
                        _userNameController.text.trim(),
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                        authController.profilePhoto,
                      ),
                      child: Text(
                        "Sign up",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Login",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Avatars extends StatelessWidget {
  const Avatars({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 124,
          height: 124,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 124,
                  height: 124,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFA826C9),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: SizedBox(
                  width: 124,
                  height: 124,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 124,
                          height: 124,
                          decoration: const ShapeDecoration(
                            color: Color(0xFFC4C4C4),
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 14.88,
                        top: 81.84,
                        child: Container(
                          width: 94.24,
                          height: 54.56,
                          decoration: const ShapeDecoration(
                            color: Colors.white,
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 39.68,
                top: 30.38,
                child: Container(
                  width: 44.64,
                  height: 44.64,
                  decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: OvalBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
