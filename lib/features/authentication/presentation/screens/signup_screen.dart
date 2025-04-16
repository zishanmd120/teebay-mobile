import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main/routes/app_routes.dart';
import '../controllers/auth_controller.dart';
import '../widgets/app_logo_widget.dart';
import '../widgets/auth_submit_button_widget.dart';
import '../widgets/auth_title_widget.dart';
import '../widgets/authentication_textfield_widget.dart';

class SignupScreen extends GetView<AuthController> {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0,),
        child: SingleChildScrollView(
          child: Form(
            key: controller.signupFormKey,
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
                AuthenticationTextFieldWidget(
                  controller: controller.fNameEditingControllerS,
                  focusNode: controller.fNameFocusNodeS,
                  hintText: 'First Name',
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'First Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                const AuthTextHeadWidget(
                  title: "Last Name",
                ),
                AuthenticationTextFieldWidget(
                  controller: controller.lNameEditingControllerS,
                  focusNode: controller.lNameFocusNodeS,
                  hintText: 'Last Name',
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Last Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                const AuthTextHeadWidget(
                  title: "Email",
                ),
                AuthenticationTextFieldWidget(
                  controller: controller.emailEditingControllerS,
                  focusNode: controller.emailFocusNodeS,
                  hintText: 'Email',
                ),
                const SizedBox(height: 20,),
                const AuthTextHeadWidget(
                  title: "Address",
                ),
                AuthenticationTextFieldWidget(
                  controller: controller.addressEditingControllerS,
                  focusNode: controller.addressFocusNodeS,
                  hintText: 'address',
                ),
                const SizedBox(height: 20,),
                const AuthTextHeadWidget(
                  title: "Password",
                ),
                AuthenticationTextFieldWidget(
                  controller: controller.passwordEditingControllerS,
                  focusNode: controller.passwordFocusNodeS,
                  hintText: 'Password',
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                const AuthTextHeadWidget(
                  title: "Confirm Password",
                ),
                AuthenticationTextFieldWidget(
                  controller: controller.confirmPasswordEditingControllerS,
                  focusNode: controller.confirmPasswordFocusNodeS,
                  hintText: 'Confirm Password',
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Confirm Password is required';
                    }
                    if (value == controller.passwordEditingControllerS.text) {
                      return 'Password did not matched';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                GestureDetector(
                  child: const AuthSubmitButtonWidget(
                    buttonName: "SignUp",
                  ),
                  onTap: (){
                    if(controller.signupFormKey.currentState!.validate()){
                      controller.signupTest(context);
                    }
                  },
                ),
                const SizedBox(height: 20,),
                RichText(text: TextSpan(
                  children: [
                    const TextSpan(text: "Already have an account?  ", style: TextStyle(color: Colors.black,),),
                    TextSpan(text: "Sign In", style: const TextStyle(color: Colors.orange,),
                      recognizer: TapGestureRecognizer()..onTap = (){
                        Get.toNamed(AppRoutes.login);
                      },
                    ),
                  ],
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
