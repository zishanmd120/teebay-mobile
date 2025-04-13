import 'package:flutter/material.dart';

class AuthTextHeadWidget extends StatelessWidget {
  final String title;
  const AuthTextHeadWidget({super.key, required this.title,});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0,),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: title, style: const TextStyle(color: Color(0xff858585), fontSize: 16.0,),),
                const TextSpan(text: " *", style: TextStyle(color: Colors.red,),),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

