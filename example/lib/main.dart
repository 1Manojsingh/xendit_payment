import 'package:flutter/material.dart';
import 'package:xendit_flutter_example/page/create_autentication_token.dart';
import 'package:xendit_flutter_example/page/create_token.dart';
import 'package:xendit_flutter_example/page/validate_util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            width: double.infinity,
          ),
          TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateTokenPage(),
                )),
            child: const Text('Create Token'),
          ),
          TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateAuthPage(),
                )),
            child: const Text('Create Authentication Token'),
          ),
          TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ValidateUtilPage(),
                )),
            child: const Text('Validation Util'),
          ),
        ],
      ),
    );
  }
}
