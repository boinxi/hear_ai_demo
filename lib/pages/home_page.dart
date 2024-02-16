import 'package:flutter/material.dart';
import 'package:hear_ai_demo/components/theme_switch.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: const [
          ThemeSwitch(),
        ],
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text('Hello World!'),
          ),
        ],
      ),
    );
  }
}
