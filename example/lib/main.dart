import 'package:flutter/material.dart';
import 'package:quick_scan/quick_scan.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScanButtonOption _option = new ScanButtonOption();
    _option.elevation = 10;
    _option.color = Colors.amber;
    _option.textColor = Colors.black12;
    _option.splashColor = Colors.amberAccent;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: QuickScan().getButton(scanButtonOption: _option),
        ),
      ),
    );
  }
}
