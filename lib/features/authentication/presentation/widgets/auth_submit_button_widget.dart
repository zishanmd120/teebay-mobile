import 'package:flutter/material.dart';

class AuthSubmitButtonWidget extends StatelessWidget {
  final String buttonName;
  const AuthSubmitButtonWidget({super.key, required this.buttonName,});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xffFFC911),
        borderRadius: BorderRadius.circular(10.0,),
      ),
      child: Text(
        buttonName,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18,),
      ),
    );
  }
}
