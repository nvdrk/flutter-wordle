
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordle/theme/style.dart';

class NeumorphicButton extends StatelessWidget {
  const NeumorphicButton({Key? key, required this.onTap, required this.title, required this.height, required this.width}) : super(key: key);

  final VoidCallback onTap;
  final String title;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        borderRadius: BorderRadius.circular(15.0),
        elevation: 10,
        shadowColor: greyTint.shade700,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: greyTint.shade700, width: 0.5),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: greyTint.shade900,
                  offset: const Offset(2, 5),
                  blurRadius: 5,
                  spreadRadius: 0.5,
                ),
                BoxShadow(
                  color: greyTint.shade700,
                  offset: const Offset(-2, -4),
                  blurRadius: 5,
                  spreadRadius: 0.1,
                ),
              ],
              color: greyTint.shade800,
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                    color: greyTint.shade200,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
