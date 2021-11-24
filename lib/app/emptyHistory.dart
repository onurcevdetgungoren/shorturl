import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.grey.shade200,
      height: deviceHeight * 2.8 / 4,
      // color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(
            "images/icons/logo.svg",
          ),
          SvgPicture.asset(
            "images/icons/illustration.svg",
          ),
          Column(
            children: [
              Text(
                "Let's Get Started!",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Paste your first link into \n  the field to shorten it",
                  style: TextStyle(
                    fontSize: 21,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
