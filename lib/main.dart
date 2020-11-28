import 'package:flutter/material.dart';
import 'dart:developer' as developer;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coin Counter',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Coin Collection'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _coins = [
    {
      'label': '2€',
      'worth': 2.0,
      'amount': 21,
    },
    {
      'label': '1€',
      'worth': 1.0,
      'amount': 43,
    },
    {
      'label': '0,50€',
      'worth': 0.5,
      'amount': 21,
    }
  ];

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      // _counter++;
    });
  }

  double _getTotalValue() {
    double sum = 0.0;
    _coins.forEach((coin) {
      sum += double.tryParse(coin['worth'].toString()) * double.tryParse(coin['amount'].toString());
    });
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
            Container(
                padding: const EdgeInsets.all(8.0), child: Text('Coin Counter'))
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xFF5e00d6),
                    Color(0xFFac1cff)
                  ])
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text('No settings yet!')
                  )
              );
            },
          )
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            HeaderWidget(),
            Expanded(
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return CoinWidget();
                  }
              )
            ),
            /*Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),*/
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF5e00d6),
        shape: const CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: 60.0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text('Total: ' + _getTotalValue().toStringAsFixed(2) + '€', style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500)),
            ),
          ),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xFF5e00d6),
                    Color(0xFFac1cff)
                  ])
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          double totalValue = _getTotalValue();
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                  content: Text(totalValue.toString())
              )
          );
        },
        tooltip: 'Add',
        child: Container(
          width: 60,
          height: 60,
          child: Icon(
            Icons.add,
            size: 40,
          ),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color(0xFFac1cff),
                  Color(0xFF5e00d6),
                ])
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Coin', style: TextStyle(fontStyle: FontStyle.italic),),
            Text('Amount', style: TextStyle(fontStyle: FontStyle.italic),),
          ],
        ),
      ),
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }
}

class CoinWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          children: [
            Text('2€', textAlign: TextAlign.left,)
          ],
        ),
      ),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }
}