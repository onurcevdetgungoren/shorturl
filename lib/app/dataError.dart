import 'package:flutter/material.dart';

class DataError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      height: deviceHeight * 2.8 / 4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color:
              Color.fromRGBO(170, 200, 220, 0.3) //  SOFT LAYER FOR OCEAN THEME
          ),
      child: Center(
          // child: CircularProgressIndicator(),
          child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              strokeWidth: deviceHeight * 0.0035,
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(50, 100, 220, 0.8)))),
    );
  }
}
