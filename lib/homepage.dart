import 'dart:async';

import 'package:flutter/material.dart';
import 'package:steak/barriers.dart';
import 'package:steak/usami.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.5;

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void startGame() {
    print('start');
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      time += 0.04;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdYaxis = initialHeight - height;
      });

      setState(() {
        if (barrierXone < -1.1) {
          barrierXone += 2.2;
        } else {
          barrierXone =- 0.05;
        }
      });

      setState(() {
        if (barrierXtwo < -1.1) {
          barrierXtwo += 2.2;
        } else {
          barrierXtwo =- 0.05;
        }
      });


      if (birdYaxis > 1.1) {
        timer.cancel();
        setState(() {
          time = 0;
          initialHeight = 0;
          birdYaxis = 0;
          gameHasStarted = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (gameHasStarted) {
                        jump();
                      } else {
                        startGame();
                      }
                    },
                    child: AnimatedContainer(
                      alignment: Alignment(0, birdYaxis),
                      duration: Duration(microseconds: 0),
                      color: Colors.blue,
                      child: MyBird(),
                    ),
                  ),
                  Container(
                    alignment: Alignment(0, -0.3),
                    child: gameHasStarted ? Text(" ") :
                    Text("탭하여 시작하세요", style: TextStyle(fontSize: 30,),),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, 1.1),
                    duration: Duration(milliseconds:  0),
                    child: MyBarrier(
                      size: 150.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, -1.1),
                    duration: Duration(milliseconds:  0),
                    child: MyBarrier(
                      size: 150.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, 1.1),
                    duration: Duration(milliseconds:  0),
                    child: MyBarrier(
                      size: 150.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, -1.1),
                    duration: Duration(milliseconds:  0),
                    child: MyBarrier(
                      size: 250.0,
                    ),
                  )
                ],
              )
          ),
          Container(
            height: 15,
            color: Colors.green,
          ),
          Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('점수', style: TextStyle(color: Colors.white, fontSize: 20),),
                        SizedBox(height: 20,),
                        Text('0', style: TextStyle(color: Colors.white, fontSize: 35),),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('최고점수', style: TextStyle(color: Colors.white, fontSize: 20),),
                        SizedBox(height: 20,),
                        Text('0', style: TextStyle(color: Colors.white, fontSize: 35),),
                      ],
                    )
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
}