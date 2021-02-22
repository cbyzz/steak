import 'dart:async';
import 'dart:io';
import 'dart:math';

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
  int score = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.5;

  double barrierXoneTopSize = 150.0;
  double barrierXoneBottomSize = 250.0;
  int barrierXoneAnim = 0;

  double barrierXtwoTopSize = 250.0;
  double barrierXtwoBottomSize = 150.0;
  int barrierXtwoAnim = 0;

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void startGame() {
    print('start');
    gameHasStarted = true;
    double gamespeed = 0;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      gamespeed += 0.0001;
      time += 0.04;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        score = score + 1;
        birdYaxis = initialHeight - height;
      });

      setState(() {
        if (barrierXone < -1.5) {
          barrierXone += 3;
          barrierXoneAnim = 0;
          // var min = 50;
          // var max = 250;
          // var rnd = new Random();
          // var r = min + rnd.nextInt(max - min);
          // barrierXoneTopSize = r.toDouble();
          // rnd = new Random();
          // r = min + rnd.nextInt(max - min);
          // barrierXoneBottomSize = r.toDouble();
        } else {
          barrierXone -= (0.03 + gamespeed);
          barrierXoneAnim = 100;
        }
      });

      setState(() {
        if (barrierXtwo < -1.5) {
          barrierXtwo += 3;
          barrierXtwoAnim = 0;

          // var min = 50;
          // var max = 250;
          // var rnd = new Random();
          // var r = min + rnd.nextInt(max - min);
          // barrierXtwoTopSize = r.toDouble();
          // rnd = new Random();
          // r = min + rnd.nextInt(max - min);
          // barrierXtwoBottomSize = r.toDouble();

        } else {
          barrierXtwo -= (0.03 + gamespeed);
          barrierXtwoAnim = 100;
        }
      });

      print(birdYaxis);
      if (birdYaxis > 1.1) {
        print('out die');
        stopGame(timer);
      } else if (barrierXone < 0.3 &&  barrierXone > -0.3 &&
          (birdYaxis < -0.6 || birdYaxis > 0.22 )) {
        print('b1 die');
        print(birdYaxis);
        stopGame(timer);
      } else if (barrierXtwo < 0.3 &&  barrierXtwo > -0.3 &&
          (birdYaxis < -0.22 || birdYaxis >  0.6)) {
        print('barrier2 die');
        print(birdYaxis);
        stopGame(timer);
      }
    });
  }

  void stopGame(Timer timer) {
    timer.cancel();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            '죽음',
            style: TextStyle(
                fontFamily: 'NotoSans',
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000)),
          ),
        ),
        backgroundColor: Colors.white,
        content: Container(
          width: 50,
          height: 50,
          child: Text('너의 점수는 = ' + score.toString()),
        ),
        actions: <Widget>[
          Row(
            children: [
              FlatButton(
                onPressed: () => exit(0),
                child: Container(
                  width: 140,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0XFF555555),
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  padding: EdgeInsets.all(13),
                  child: Text('종료',
                      style: TextStyle(
                          fontFamily: 'NotoSans',
                          fontSize: 20,
                          color: Colors.white)),
                ),
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    time = 0;
                    initialHeight = 0;
                    birdYaxis = 0;
                    gameHasStarted = false;
                    barrierXone = 1;
                    barrierXtwo = barrierXone + 1.5;
                    barrierXoneAnim = 0;
                    barrierXtwoAnim = 0;
                    score = 0;
                  });
                  Navigator.of(context).pop(false);
                },
                child: Container(
                  width: 140,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0XFF8634A2),
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  padding: EdgeInsets.all(13),
                  child: Text('다시하기',
                      style: TextStyle(
                          fontFamily: 'NotoSans',
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (gameHasStarted) {
            jump();
          } else {
            startGame();
          }
        },
        child: Column(
          children: [
            Expanded(
              flex: 3,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      alignment: Alignment(0, birdYaxis),
                      duration: Duration(microseconds: 50),
                      color: Colors.blue,
                      child: MyBird(),
                    ),
                    Container(
                      alignment: Alignment(0, -0.3),
                      child: gameHasStarted ? Text(" ") :
                      Text("탭하여 시작하세요", style: TextStyle(fontSize: 30,),),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXone, 1.1),
                      duration: Duration(milliseconds:  barrierXoneAnim),
                      child: MyBarrier(
                        size: barrierXoneBottomSize,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXone, -1.1),
                      duration: Duration(milliseconds:  barrierXoneAnim),
                      child: MyBarrier(
                        size: barrierXoneTopSize,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXtwo, 1.1),
                      duration: Duration(milliseconds:  barrierXtwoAnim),
                      child: MyBarrier(
                        size: barrierXtwoBottomSize,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXtwo, -1.1),
                      duration: Duration(milliseconds:  barrierXtwoAnim),
                      child: MyBarrier(
                        size: barrierXtwoTopSize,
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
                          Text(score.toString(), style: TextStyle(color: Colors.white, fontSize: 35),),
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
      ),
    );
  }
}