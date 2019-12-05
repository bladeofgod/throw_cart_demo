


import 'dart:ui';

import 'package:flutter/material.dart';

class ParabolaAnimateWidget extends StatefulWidget{
  final GlobalKey rootKey;
  final Offset startOffset;
  final Offset endOffset;
  final Widget animateWidget;
  final Function animateCallback;
  final int duration;


  ParabolaAnimateWidget(this.rootKey,this.startOffset,this.endOffset,this
      .animateWidget,this.animateCallback,{int duration = -1})
    : this.duration = duration,assert(animateWidget != null);


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ParabolaAnimateWidgetState(rootKey,startOffset,endOffset,
      animateWidget,animateCallback,this.duration);
  }

}

class ParabolaAnimateWidgetState extends State<ParabolaAnimateWidget> with
    SingleTickerProviderStateMixin {
  final GlobalKey rootKey;
  final Offset startOffset;
  final Offset endOffset;
  final Widget animateWidget;
  final Function animateCallback;
  int _animationDuration ;

  ParabolaAnimateWidgetState(this.rootKey,this.startOffset,this.endOffset,
  this.animateWidget,this.animateCallback,int duration)
    : _animationDuration = duration == -1 ? 1 : duration;



  AnimationController _controller;
  Animation _animation;


  double widgetLeft = 0.0;
  double widgetTop = 0.0;

  double animateLen = 0.0;
  PathMetric animatePM ;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this,duration: Duration(seconds:
    _animationDuration));


    WidgetsBinding.instance.addPostFrameCallback((_){
      generateAnimateAttr();
      startAnimation();
    });
    widgetLeft = startOffset.dx ==null ? widgetLeft : startOffset.dx;
    widgetTop = startOffset.dy == null ? widgetTop : startOffset.dy;

  }

  generateAnimateAttr(){
    //RenderBox startRB = startKey.currentContext.findRenderObject();
//    Offset startOffset = startRB.localToGlobal(Offset.zero,ancestor: rootKey.currentContext.findRenderObject());
//    RenderBox endRB = endKey.currentContext.findRenderObject();
//    Offset endOffset = endRB.localToGlobal(Offset.zero,ancestor: rootKey.currentContext.findRenderObject());
    Path path = getPath(startOffset, endOffset);
    PathMetrics pms = path.computeMetrics();
    animatePM = pms.elementAt(0);
    animateLen = animatePM.length;

  }

  Path getPath(Offset start,Offset end) {

    //print("start offset :${start.toString()}");
    double controlPointX = start.dx > end.dx ? start.dx : end.dx;
    Path path = Path();
    path.moveTo(start.dx,start.dy);
    path.quadraticBezierTo(controlPointX / 2, start.dy, end.dx, end.dy);
    //path.cubicTo(size.width / 4, 3 * size.height / 4, 3 * size.width / 4, size.height / 4, size.width, size.height);

    return path;
  }



  @override
  Widget build(BuildContext context) {

    return Positioned(
      left: widgetLeft,
      top: widgetTop,
      child: animateWidget,
    );
  }


  startAnimation(){

    _animation = Tween(begin: 0.0,end: animateLen).animate(_controller)
        ..addListener((){
          //print("animation value ${_animation.value}");
          double tempStart = _animation.value;
          Tangent t = animatePM.getTangentForOffset(tempStart);
          setState(() {
            widgetLeft = t.position.dx;
            widgetTop = t.position.dy;
          });
        })
        ..addStatusListener((status){
          animateCallback(status);
          if(status == AnimationStatus.completed){
            _controller?.stop();
            _controller?.dispose();
          }
        });
    _controller.forward();
  }

}





















