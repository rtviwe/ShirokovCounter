import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Широков',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Широков'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counterYasno = 0;
  int _counterPonyatno = 0;
  int _counterDa = 0;

  final String yasno = 'yasno';
  final String ponyatno = 'ponyatno';
  final String da = 'da';

  @override
  void initState() {
    super.initState();

    _setCounters();
  }

  Future<void> _setCounters() async {
    final prefs = await SharedPreferences.getInstance();
    int counterYasno = prefs.getInt(yasno);
    int counterPonyatno = prefs.getInt(ponyatno);
    int counterDa = prefs.getInt(da);

    if (counterYasno == null) {
      prefs.setInt(yasno, 0);
    }
    setState(() {
      _counterYasno = prefs.getInt(yasno);
    });

    if (counterPonyatno == null) {
      prefs.setInt(ponyatno, 0);
    }
    setState(() {
      _counterPonyatno = prefs.getInt(ponyatno);
    });

    if (counterDa == null) {
      prefs.setInt(da, 0);
    }
    setState(() {
      _counterDa = prefs.getInt(da);
    });
  }

  void _incrementYasno() {
    setState(() {
      _incrementCounter(yasno);
      _counterYasno++;
    });
  }

  void _incrementPonyatno() {
    setState(() {
      _incrementCounter(ponyatno);
      _counterPonyatno++;
    });
  }

  void _incrementDa() {
    setState(() {
      _incrementCounter(da);
      _counterDa++;
    });
  }

  void _incrementCounter(String key) async {
    final prefs = await SharedPreferences.getInstance();
    int counter = prefs.getInt(key);
    counter++;
    await prefs.setInt(key, counter);
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
            //'$_counterYasno'
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
