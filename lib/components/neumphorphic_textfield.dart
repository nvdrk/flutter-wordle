import 'package:flutter/material.dart';
import 'package:flutter_wordle/presentation/game/game_state.dart';
import 'package:flutter_wordle/app/theme/style.dart';

class NeumorphicTextFormField extends StatelessWidget {
  const NeumorphicTextFormField({
    Key? key,
    required this.controller,
    required this.node,
    required this.enabled,
    required this.status,
    required this.index,
    this.onTap,
  }) : super(key: key);

  final MatchStatus status;
  final FocusNode node;
  final int index;
  final bool enabled;
  final TextEditingController controller;
  final VoidCallback? onTap;

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
          cursorHeight: 0,
          controller: controller,
          enabled: enabled,
          focusNode: node,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.none,
          onTap: onTap,
          onChanged: (input) {
            if (input != '') {
              node.nextFocus();
            } else {
              node.previousFocus();
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