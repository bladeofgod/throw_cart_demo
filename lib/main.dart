import 'dart:ui';


import 'package:add_cart_parabola/add_cart_parabola.dart';
import 'package:flutter/material.dart';




void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;

  GlobalKey floatKey = GlobalKey();
  GlobalKey rootKey = GlobalKey();
  Offset floatOffset ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      RenderBox renderBox = floatKey.currentContext.findRenderObject();
      floatOffset = renderBox.localToGlobal(Offset.zero);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Container(
        key: rootKey,
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey,
        child: ListView(
          children: List.generate(40, (index){
            return generateItem(index);
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        key: floatKey,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
  Widget generateItem(int index){

    //GlobalKey itemKey = GlobalKey();
    Text text = Text("item $index",style: TextStyle(fontSize:
    25),);


//    RaisedButton rb  = RaisedButton(
//      key: itemKey,
//      color: Colors.blue,
//      child: Text("button $index"),
//      onPressed: (){
//        setState(() {
//          OverlayEntry entry = OverlayEntry(
//            builder: (ctx){
//              return ParabolaAnimateWidget(rootKey,itemKey,floatKey);
//            }
//          );
//          Overlay.of(rootKey.currentContext).insert(entry);
//        });
//
//      },
//    );
    Offset temp;
    return GestureDetector(
      onPanDown: (details){
        temp = new Offset(details.globalPosition.dx, details.globalPosition
            .dy);
      },
      onTap: (){
        Function callback ;
        setState(() {
          OverlayEntry entry = OverlayEntry(
              builder: (ctx){
//                RenderBox renderBox = itemKey.currentContext.findRenderObject();
//                Offset itemOffset = renderBox.localToGlobal(Offset.zero,
//                    ancestor: rootKey.currentContext.findRenderObject());
//                print("item offset  :${itemOffset.toString()}    float offset"
//                    " ${floatOffset.toString()}");
                /// root key：根widget key， 主要用于定位
                /// temp:点击坐标，开始位置。floatOffset 结束坐标
                ///Icon：传入想弹出的widget
                ///call back: 会回传一个动画执行状态
                ///duration： 动画时间 可选，默认1秒
                ///

                return ParabolaAnimateWidget(rootKey,temp,floatOffset,
                    Icon(Icons.cancel,color: Colors.greenAccent,),callback,);
              }
          );

          callback = (status){
            if(status == AnimationStatus.completed){
              entry?.remove();
            }
          };

          Overlay.of(rootKey.currentContext).insert(entry);
        });
      },
      child: Container(
        color: Colors.orange,
        child: text,
      ),
    );



  }



}











