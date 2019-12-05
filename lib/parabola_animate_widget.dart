


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
    return ParabolaAnimateWidgetState();
  }

}

class ParabolaAnimateWidgetState extends State<ParabolaAnimateWidget> with
    SingleTickerProviderStateMixin {



  ParabolaAnimateWidgetState();



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
    widget.duration <=0 ? 1 : widget.duration));


    WidgetsBinding.instance.addPostFrameCallback((_){
      if(widget.startOffset == null || widget.endOffset == null){
        widget.animateCallback(AnimationStatus.completed);
        return;
      }
      generateAnimateAttr();
      startAnimation();
    });
    widgetLeft = widget.startOffset?.dx ==null ? widgetLeft : widget.startOffset.dx;
    widgetTop = widget.startOffset?.dy == null ? widgetTop : widget.startOffset.dy;

  }

  generateAnimateAttr(){
    //RenderBox startRB = startKey.currentContext.findRenderObject();
//    Offset startOffset = startRB.localToGlobal(Offset.zero,ancestor: rootKey.currentContext.findRenderObject());
//    RenderBox endRB = endKey.currentContext.findRenderObject();
//    Offset endOffset = endRB.localToGlobal(Offset.zero,ancestor: rootKey.currentContext.findRenderObject());
    Path path = getPath();
    PathMetrics pms = path.computeMetrics();
    animatePM = pms.elementAt(0);
    animateLen = animatePM.length;

  }

  Path getPath() {

    //print("start offset :${start.toString()}");
    double controlPointX = widget.startOffset.dx > widget.endOffset.dx ?
    widget.startOffset.dx : widget.endOffset.dx;
    Path path = Path();
    path.moveTo(widget.startOffset.dx,widget.startOffset.dy);
    path.quadraticBezierTo(controlPointX / 2, widget.startOffset.dy, widget.endOffset.dx, widget.endOffset.dy);
    //path.cubicTo(size.width / 4, 3 * size.height / 4, 3 * size.width / 4, size.height / 4, size.width, size.height);

    return path;
  }



  @override
  Widget build(BuildContext context) {

    return Positioned(
      left: widgetLeft,
      top: widgetTop,
      child: widget.animateWidget,
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
          widget.animateCallback(status);
          if(status == AnimationStatus.completed){
            _controller?.stop();
            _controller?.dispose();
          }
        });
    _controller.forward();
  }

}





















