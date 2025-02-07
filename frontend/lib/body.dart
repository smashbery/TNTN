import 'package:flutter/material.dart';

class AppBody extends StatelessWidget {
  const AppBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Add your backend integration here (e.g., call API)
            },
            child: Text('Bulletins'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add navigation or functionality for Messages
            },
            child: Text('Messages'),
          ),
        ],
      ),
    );
  }
}
