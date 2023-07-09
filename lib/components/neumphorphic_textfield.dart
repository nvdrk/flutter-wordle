import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordle/game/game_state.dart';
import 'package:flutter_wordle/theme/style.dart';

class NeumorphicTextFormField extends StatelessWidget {
  const NeumorphicTextFormField({
    Key? key,
    required this.controller,
    required this.enabled,
    required this.status,
  }) : super(key: key);

  final MatchStatus status;
  final bool enabled;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: greyTint.shade300, width: 0.5),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [
            0.1,
            0.99,
          ],
          colors: [
            greyTint.shade300,
            greyTint.shade100,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          controller: controller,
          enabled: enabled,
          //focusNode: focus,
          textInputAction: TextInputAction.next,
          onChanged: (input) {
            if (input != '') {
              FocusScope.of(context).nextFocus();
              controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length));
            } else {
              debugPrint('prev');
              controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length));
              FocusScope.of(context).previousFocus();
            }
          },
          decoration: const InputDecoration(
            semanticCounterText: null,
            border: InputBorder.none,
            counter: null,
            counterText: '',
          ),
          textAlign: TextAlign.center,
          textCapitalization: TextCapitalization.characters,
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
              fontSize: 30,
              color: status == MatchStatus.fully
                  ? good
                  : status == MatchStatus.contained
                  ? mediumAlt
                  : !enabled
                  ? greyTint.shade700
                  : greyTint.shade500),
          maxLength: 1,
        ),
      ),
    );
  }
}