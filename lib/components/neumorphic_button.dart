
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordle/theme/style.dart';

class NeumorphicButton extends StatefulWidget {
  const NeumorphicButton({Key? key, required this.onTap, required this.title, required this.height, required this.width, required this.isToggle, required this.hasHapticFeedBack}) : super(key: key);

  final VoidCallback onTap;
  final String title;
  final double height;
  final double width;
  final bool isToggle;
  final bool hasHapticFeedBack;

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {

  bool _isElevated = true;

  void _toggle() {
    setState(() {
      _isElevated = !_isElevated;
    });
    if (!widget.isToggle) {
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          _isElevated = !_isElevated;
        });
        widget.onTap();
      });
    } else {
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Material(
        borderRadius: BorderRadius.circular(15.0),
        elevation: 10,
        shadowColor: greyTint.shade700,
        child: GestureDetector(
          onTap: () => _toggle(),
          child: AnimatedContainer(
            decoration: BoxDecoration(
              border: Border.all(color: greyTint.shade700, width: 0.5),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              gradient: _isElevated ? null :
              LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [
                  0.05,
                  1.2,
                ],
                colors: [
                  greyTint.shade900,
                  greyTint.shade700,
                ],
              ),
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
                  spreadRadius: 0.5,
                ),
              ],
              color: greyTint.shade800,
            ),
            duration: const Duration(milliseconds: 100),

            child: Center(
              child: Text(
                widget.title,
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
