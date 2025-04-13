import 'package:flutter/material.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTXmE8iVLC7BBxfTpxcCwwE8TRhFKDxLh2Ng&s",
      height: 80,
      width: 200,
      fit: BoxFit.cover,
    );
  }
}
