import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shirokov_counter/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: TITLE),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counterYasno = 0;
  int _counterPonyatno = 0;
  int _counterDa = 0;

  bool shirokovState = false;

  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _setCounters();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
  }

  Future<void> _setCounters() async {
    final prefs = await SharedPreferences.getInstance();
    int counterYasno = prefs.getInt(YASNO);
    int counterPonyatno = prefs.getInt(PONYATNO);
    int counterDa = prefs.getInt(DA);

    if (counterYasno == null) {
      prefs.setInt(YASNO, 0);
    }
    setState(() {
      _counterYasno = prefs.getInt(YASNO);
    });

    if (counterPonyatno == null) {
      prefs.setInt(PONYATNO, 0);
    }
    setState(() {
      _counterPonyatno = prefs.getInt(PONYATNO);
    });

    if (counterDa == null) {
      prefs.setInt(DA, 0);
    }
    setState(() {
      _counterDa = prefs.getInt(DA);
    });
  }

  void _incrementYasno() {
    _animateShirokov();
    setState(() {
      _incrementCounter(YASNO);
      _counterYasno++;
    });
  }

  void _incrementPonyatno() {
    _animateShirokov();
    setState(() {
      _incrementCounter(PONYATNO);
      _counterPonyatno++;
    });
  }

  void _incrementDa() {
    _animateShirokov();
    setState(() {
      _incrementCounter(DA);
      _counterDa++;
    });
  }

  void _incrementCounter(String key) async {
    final prefs = await SharedPreferences.getInstance();
    int counter = prefs.getInt(key);
    counter++;
    await prefs.setInt(key, counter);
  }

  Future<Null> _animateShirokov() async {
    try {
      if (shirokovState) {
        await _animationController.forward();
        await _animationController.reverse();
      } else {
        await _animationController.forward();
      }
    } on TickerCanceled {} finally {
      shirokovState = !shirokovState;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: _animationController,
              builder: (BuildContext context, Widget _widget) {
                return Transform.rotate(
                  angle: _animationController.value * 2 * pi,
                  child: Image.asset('assets/shirokov.png'),
                );
              },
            ),
            RaisedButton(
              child: Text('Ясно $_counterYasno'),
              onPressed: _incrementYasno,
            ),
            RaisedButton(
              child: Text('Понятно $_counterPonyatno'),
              onPressed: _incrementPonyatno,
            ),
            RaisedButton(
              child: Text('Да $_counterDa'),
              onPressed: _incrementDa,
            ),
          ],
        ),
      ),
    );
  }
}
