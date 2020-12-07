import 'package:coin_counter/dots-indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InstructionsOverlay extends StatefulWidget {
  InstructionsOverlay({
    Key key,
    this.cancelCallback,
    this.skipCallback,
    this.doneCallback,
  }) : super(key: key);

  final void Function() cancelCallback;
  final void Function() skipCallback;
  final void Function() doneCallback;

  @override
  InstructionsOverlayState createState() => InstructionsOverlayState();
}

class InstructionsOverlayState extends State<InstructionsOverlay> {
  PageController _pageController = PageController();
  double currentPage = 0;

  List<Widget> _pages = [
    Image.asset('assets/Instruction1.png'),
    Image.asset('assets/Instruction2.png'),
    Image.asset('assets/Instruction3.png'),
  ];

  @override
  void initState() {
    _pageController.addListener((){
      setState(() {
        currentPage = _pageController.page;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0x77000000),
        height: double.infinity,
        child: Padding(
            padding: EdgeInsets.only(bottom: 60, left: 50, right: 50),
            child: Center(
              child: Container(
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Instructions', style: Theme.of(context).textTheme.headline6),
                        Padding(padding: EdgeInsets.only(top: 5)),
                        Container(
                          height: 200,
                          width: 200,
                          child: PageView(
                            controller: _pageController,
                            children: _pages,
                          ),
                        ),
                        DotsIndicator(
                          controller: _pageController,
                          itemCount: _pages.length,
                          color: Colors.grey.shade300,
                          selectedColor: Colors.purple,
                        ),
                        ButtonBar(
                          buttonPadding: EdgeInsets.zero,
                          alignment: MainAxisAlignment.spaceEvenly,
                          // buttonPadding: EdgeInsets.only(left: 5, right: 5, top: 1, bottom: 1),
                          children: [
                            FlatButton(child: Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade300),), onPressed: this.widget.cancelCallback,),
                            FlatButton(child: Text('SKIP', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade300),), onPressed: this.widget.skipCallback,),
                            FlatButton(child: Text('NEXT >', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),), onPressed: () => {
                              _pageController.animateToPage(_pageController.page.toInt() + 1, duration: Duration(milliseconds: 300), curve: Curves.ease)
                            }),
                          ],
                        ),
                      ],
                    ),
                  )
              ),
            )
        )
    );
  }
}