import 'dart:io';

import 'package:camera/camera.dart';
import 'package:coin_counter/camera.dart';
import 'package:flutter/material.dart';
import 'package:coin_counter/api.dart';

import 'insturction-overlay..dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      title: 'Coin Counter',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Coin Collection', camera: firstCamera,),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final CameraDescription camera;

  MyHomePage({
    Key key,
    this.title,
    @required this.camera,
  }) : super(key: key);

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

  OverlayEntry _instructionOverlayEntry;

  var _coins = [
    {
      'label': '2,00€',
      'worth': 2.0,
      'amount': 21,
    },
    {
      'label': '1,00€',
      'worth': 1.0,
      'amount': 43,
    },
    {
      'label': '0,50€',
      'worth': 0.5,
      'amount': 21,
    },
    {
      'label': '0,20€',
      'worth': 0.2,
      'amount': 0,
    },
    {
      'label': '0,10€',
      'worth': 0.1,
      'amount': 21,
    },
    {
      'label': '0,05€',
      'worth': 0.05,
      'amount': 21,
    },
    {
      'label': '0,02€',
      'worth': 0.02,
      'amount': 21,
    },
    {
      'label': '0,01€',
      'worth': 0.01,
      'amount': 21,
    }
  ];

  void _addCoins(List coins) {
    coins.forEach((coin) {
      int index = _coins.indexWhere((e) => e['label'] == coin['label']);
      int old = int.tryParse(_coins[index]['amount'].toString());
      setState(() {
        _coins[index]['amount'] = old + 1;
      });
    });
  }

  double _getTotalValue() {
    double sum = 0.0;
    _coins.forEach((coin) {
      sum += double.tryParse(coin['worth'].toString()) * double.tryParse(coin['amount'].toString());
    });
    return sum;
  }

  void _takeImage() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => TakePictureScreen(camera: this.widget.camera, takeImageCallback: this._takeImageCallback,))
    );
  }

  void _instructionOverlayOn() {
    this._instructionOverlayEntry = OverlayEntry(builder: (context) =>
        InstructionsOverlay(
          cancelCallback: _instructionOverlayOff,
          skipCallback: () {
            _instructionOverlayOff();
            _takeImage();
          },
          doneCallback: () {
            _instructionOverlayOff();
            _takeImage();
          },
        ));
    Overlay.of(context).insert(this._instructionOverlayEntry);
  }

  void _instructionOverlayOff() {
    this._instructionOverlayEntry.remove();
  }

  Future<void> _takeImageCallback(String imagePath) async {
    try {
      Map response = await countCoins(imagePath);
      if (response['error'] != null) {
        // TODO: handle errors
      } else {
        _addCoins(response['result']['coins']);

        // Delete file
        File image = File(imagePath);
        await image.delete();
      }
    } catch (e) {
      print(e);
    }
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
      extendBody: true,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(left: 5.0)),
            Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
            Container(
                padding: EdgeInsets.only(left: 10.0),
                child: Text('Coin Counter'))
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
          ),
          Padding(padding: EdgeInsets.only(right: 8.0)),
        ],
      ),
      body: Stack(
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
          _instructionOverlayOn();
          // _takeImage();
          // double totalValue = _getTotalValue();
          // _scaffoldKey.currentState.showSnackBar(
          //    SnackBar(
          //        content: Text(totalValue.toString())
          //    )
          //);
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
              padding: EdgeInsets.only(left: 20, right: 25),
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
    '2,00€': 'assets/2,00€.png',
    '1,00€': 'assets/1,00€.png',
    '0,50€': 'assets/0,50€.png',
    '0,20€': 'assets/0,20€.png',
    '0,10€': 'assets/0,10€.png',
    '0,05€': 'assets/0,05€.png',
    '0,02€': 'assets/0,02€.png',
    '0,01€': 'assets/0,01€.png',
  };
  return paths[label];
}