import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {

  final size;

  MyBarrier({this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: size,
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(width: 5, color: Colors.green[800]),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}