import 'package:flutter/material.dart';
import 'body.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TNTN Frontend'),
      ),
      body: AppBody(),
    );
  }
}
