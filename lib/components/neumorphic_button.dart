import 'package:flutter/material.dart';
import 'package:flutter_wordle/app/theme/style.dart';

class NeumorphicButton extends StatefulWidget {
  const NeumorphicButton(
      {Key? key,
      required this.onTap,
      required this.title,
      required this.height,
      required this.width,
      required this.isToggle,
      required this.hasHapticFeedBack})
      : super(key: key);

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
        elevation: 5,
        shadowColor: greyTint.shade200,
        child: GestureDetector(
          onTap: () => _toggle(),
          child: AnimatedContainer(
            decoration: BoxDecoration(
              border: Border.all(color: greyTint.shade200, width: 0.5),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              gradient: _isElevated
                  ? null
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [
                        0.05,
                        1.2,
                      ],
                      colors: [
                        greyTint.shade100,
                        greyTint.shade300,
                      ],
                    ),
              boxShadow: [
                BoxShadow(
                  color: greyTint.shade400,
                  offset: const Offset(2, 5),
                  blurRadius: 5,
                  spreadRadius: 0.5,
                ),
                BoxShadow(
                  color: greyTint.shade100,
                  offset: const Offset(-2, -4),
                  blurRadius: 5,
                  spreadRadius: 0.5,
                ),
              ],
              color: greyTint.shade200,
            ),
            duration: const Duration(milliseconds: 100),
            child: Center(
              child: Text(
                widget.title,
                style: TextStyle(
                    shadows: [
                      Shadow(
                        offset: const Offset(2, 2),
                        blurRadius: 2.0,
                        color: greyTint.shade50,
                      ),
                      Shadow(
                        offset: const Offset(-0.5, -0.5),
                        blurRadius: 2.0,
                        color: greyTint.shade700,
                      ),
                    ],
                    color: greyTint.shade700,
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
