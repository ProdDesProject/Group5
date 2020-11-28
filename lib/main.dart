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
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: ListView.builder(
                itemCount: _coins.length,
                itemBuilder: (BuildContext context, int index) {
                  String label = _coins[index]['label'];
                  int amount = _coins[index]['amount'];
                  return CoinWidget(label: label, amount: amount,);
                }
              )
            ),
            HeaderWidget(),
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
        padding: EdgeInsets.only(left: 25, right: 25),
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
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
    );
  }
}

class CoinWidget extends StatelessWidget {
  const CoinWidget({
    Key key,
    this.label,
    this.amount,
  }) : super(key: key);

  final String label;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder()
        ),
        child: Container(
          height: 53,
          color: Colors.white,
          alignment: Alignment.topCenter,
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(left: 22, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        getCoinImagePath(this.label),
                        fit: BoxFit.contain,
                        height: 40,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(this.label, textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                      ),
                    ],
                  ),
                  Text(this.amount.toString(), textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),),
                ],
              ),
            ),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}

String getCoinImagePath(String label) {
  var paths = {
    '2€': 'assets/Common_face_of_two_euro_coin.jpg',
    '1€': 'assets/Common_face_of_one_euro_coin.jpg',
    '0,50€': 'assets/Common_face_of_fifty_eurocent_coin.jpg',
  };
  return paths[label];
}