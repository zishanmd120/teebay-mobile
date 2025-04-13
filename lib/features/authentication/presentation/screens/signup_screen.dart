import 'package:flutter/material.dart';

import '../widgets/app_logo_widget.dart';
import '../widgets/auth_submit_button_widget.dart';
import '../widgets/auth_title_widget.dart';
import '../widgets/authentication_textfield_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0,),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40,),
              const AppLogoWidget(),
              const Text(
                "Signup to the TeeBay App",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20,),
              const AuthTextHeadWidget(
                title: "First Name",
              ),
              const AuthenticationTextFieldWidget(
                // controller: controller.passwordEditingController,
                // focusNode: controller.passwordFocusNode,
                hintText: 'First Name',
              ),
              const SizedBox(height: 20,),
              const AuthTextHeadWidget(
                title: "Last Name",
              ),
              const AuthenticationTextFieldWidget(
                // controller: controller.passwordEditingController,
                // focusNode: controller.passwordFocusNode,
                hintText: 'Last Name',
              ),
              const SizedBox(height: 20,),
              const AuthTextHeadWidget(
                title: "Email",
              ),
              const AuthenticationTextFieldWidget(
                // controller: controller.passwordEditingController,
                // focusNode: controller.passwordFocusNode,
                hintText: 'Email',
              ),
              const SizedBox(height: 20,),
              const AuthTextHeadWidget(
                title: "Address",
              ),
              const AuthenticationTextFieldWidget(
                // controller: controller.passwordEditingController,
                // focusNode: controller.passwordFocusNode,
                hintText: 'address',
              ),
              const SizedBox(height: 20,),
              const AuthTextHeadWidget(
                title: "Password",
              ),
              const AuthenticationTextFieldWidget(
                // controller: controller.passwordEditingController,
                // focusNode: controller.passwordFocusNode,
                hintText: 'Password',
              ),
              const SizedBox(height: 20,),
              const AuthTextHeadWidget(
                title: "Confirm Password",
              ),
              const AuthenticationTextFieldWidget(
                // controller: controller.passwordEditingController,
                // focusNode: controller.passwordFocusNode,
                hintText: 'Confirm Password',
              ),
              const SizedBox(height: 20,),
              GestureDetector(
                child: const AuthSubmitButtonWidget(
                  buttonName: "SignUp",
                ),
                onTap: (){
                  // controller.loginTest();
                },
              ),
              const SizedBox(height: 20,),
              RichText(text: const TextSpan(
                children: [
                  TextSpan(text: "Already have an account? ", style: TextStyle(color: Colors.black,),),
                  TextSpan(text: "Sign In", style: TextStyle(color: Colors.blue,),),
                ],
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
