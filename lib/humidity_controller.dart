import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'humidity_controller_painter.dart';

class HumidityController extends StatefulWidget {
  // final int lastHumi;
  // final int humi;
  // HumidityController({this.lastHumi, this.humi});
  @override
  _HumidityControllerState createState() => _HumidityControllerState();
}

class _HumidityControllerState extends State<HumidityController>
    with TickerProviderStateMixin {
  var _tapPosition = Offset.zero;
  var _dragePosition = Offset.infinite;
  var _validPressed = false;
  var shouldDraw = false;
  double humi, temp;
  Animation<double> animation;
  AnimationController controller;
  Tween<double> animationTween;

  Timer timer;
  int _start = 50;

  void startTimer() {
    timer = new Timer.periodic(
      Duration(seconds: 3),
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            setNewPosition();
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    humi = 86.5;
    temp = 30.6;
    animationTween = Tween(begin: 0, end: humi.toDouble());
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    animation = animationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        // if (status == AnimationStatus.completed) {
        //   print("AnimationStatus.completed");
        // } else if (status == AnimationStatus.dismissed) {
        //   print("AnimationStatus.dismissed");
        //   // controller.forward();
        // } else if (status == AnimationStatus.forward) {
        //   print("AnimationStatus.forward");
        // }
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void setNewPosition() {
    animationTween.begin = humi.toDouble();
    controller.reset();
    var rdHumi1 = Random().nextInt(100).toDouble();
    var rdHumi2 = Random().nextInt(100).toDouble() / 100;
    var rdTemp1 = 20 + Random().nextInt(20).toDouble();
    var rdTemp2 = Random().nextInt(100).toDouble() / 100;
    humi = rdHumi1 + rdHumi2;
    temp = rdTemp1 + rdTemp2;
    print("NewHumi: ${humi.toInt()}");
    animationTween.end = humi.toDouble();
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF173051),
      floatingActionButton: FloatingActionButton(onPressed: () {
        // setNewPosition();
        startTimer();
      }),
      body: SafeArea(
        child: AnimatedBuilder(
            animation: animation,
            builder: (context, snapshot) {
              return Container(
                width: _screenSize.width,
                height: _screenSize.height,
                child: GestureDetector(
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: HumidityControllerPainter(
                        currentHumidity: animation.value,
                        currentTemperature: temp,
                        currentCelsius: 32,
                        tapPosition: _tapPosition,
                        dragePosition: _dragePosition,
                        validPressed: _validPressed,
                        onShouldDraw: (bool _shouldDraw) {
                          shouldDraw = _shouldDraw;
                        }),
                  ),
                  // onTapDown: (details) {
                  //   setState(() {
                  //     if (_shouldDraw) {
                  //       _validPressed = true;
                  //     }
                  //     _tapPosition = details.localPosition;
                  //     print("onTapDown $_tapPosition");
                  //   });
                  // },
                  // onTapUp: (detail) {
                  //   setState(() {
                  //     _tapPosition = Offset.zero;
                  //     _validPressed = false;
                  //   });
                  //   print("onTapUp $_tapPosition");
                  // },
                  // onVerticalDragStart: (details) {
                  //   setState(() {
                  //     if (_shouldDraw) {
                  //       _validPressed = true;
                  //     }
                  //     _tapPosition = details.localPosition;
                  //   });

                  //   print("onVerticalDragStart $_tapPosition");
                  // },
                  // onVerticalDragEnd: (details) {
                  //   setState(() {
                  //     _tapPosition = Offset.zero;
                  //     _validPressed = false;
                  //   });
                  //   print("onVerticalDragEnd $_tapPosition");
                  // },
                  // onVerticalDragUpdate: (details) {
                  //   setState(() {
                  //     if (_shouldDraw) {
                  //       _validPressed = true;
                  //       _dragePosition = details.localPosition;
                  //     }
                  //   });
                  //   print("onVerticalDragUpdate $_tapPosition");
                  // },
                ),
              );
            }),
      ),
    );
  }
}
