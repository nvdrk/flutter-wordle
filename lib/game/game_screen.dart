import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:word_salad/components/appbar.dart';
import 'package:word_salad/game/game_state.dart';
import 'package:word_salad/game/game_provider.dart';
import 'package:word_salad/theme/style.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class GameLayout extends ConsumerWidget {
  const GameLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(wordProvider);
    return value.when(
      data: (value) => GameScreen(word: value),
      error: ErrorLayout.new,
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key, required this.word});

  final String word;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameProvider);

    return SafeArea(
      child: Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: MoveAppBar(title: 'FLUTTER WORDLE', isPop: true,)),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          child: Center(
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                      height: 550,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          elevation: 1,
                          child: TextFields(
                            trials: state.trials,
                            attempt: state.attempt,
                            wordLength: state.wordLength,
                            solution: word,
                          ),
                        ),
                      )),
                ),
                SizedBox(
                  height: 500,
                    child: Alphabet(state: state,)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextFields extends ConsumerStatefulWidget {
  const TextFields({
    Key? key,
    required this.trials,
    required this.attempt,
    required this.wordLength,
    required this.solution,
  }) : super(key: key);

  final String solution;
  final int trials;
  final int wordLength;
  final int attempt;

  @override
  ConsumerState<TextFields> createState() => _TextFieldsState();
}

class _TextFieldsState extends ConsumerState<TextFields> {
  late List<List<TextEditingController>> _gridController;

  @override
  void initState() {
    super.initState();
    _gridController = _getGridController(widget.wordLength, widget.trials);
  }
  
  @override
  void dispose() {
    final flatList = _gridController.expand((element) => element).toList();
    for (final controller in flatList) {
      controller.dispose();
    }
    super.dispose();
  }

  List<List<TextEditingController>> _getGridController(int cols, int rows) {
    final controllerArray = List.generate(
        rows,
        (i) => List.generate(cols + 1, (_) => TextEditingController(),
            growable: false),
        growable: false);
    return controllerArray;
  }

  void _submit(int index) async {
    ref.read(gameProvider.notifier).setWord(widget.solution);
    final charList = <String>[];
    for (var element in _gridController[index]) {
      charList.add(element.text);
    }
    charList.removeWhere((element) => element == '');
    if (charList.length < widget.wordLength) {
      bool canVibrate = await Vibrate.canVibrate;
      if (canVibrate) {
        var type = FeedbackType.heavy;
        Vibrate.feedback(type);
      }
      return;
    }
    final guess = charList.join('').trim();
    ref.read(gameProvider.notifier).submit({index: guess});
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Flexible(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.wordLength,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: widget.trials * widget.wordLength,
              itemBuilder: (BuildContext context, int index) {
                final rowIndex = index ~/ widget.wordLength;
                final colIndex = index % widget.wordLength;

                return CustomTextFormField(
                  enabled: (rowIndex == state.attempt),
                  status: (state.validation.length > rowIndex)
                      ? state.validation
                              .where((element) => element.rowIndex == rowIndex)
                              .first
                              .getMatchStatus(colIndex) ??
                          MatchStatus.none
                      : MatchStatus.none,
                  controller: _gridController[rowIndex][colIndex],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5
                ),
                onPressed: () => _submit(state.attempt),
                child: const Text('Go'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorLayout extends StatelessWidget {
  const ErrorLayout(this.error, [this.stackTrace]);

  final Object error;

  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key? key,
      required this.controller,
      required this.enabled,
      required this.status,
      })
      : super(key: key);

  final MatchStatus status;
  final bool enabled;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).shadowColor, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).cardColor,
              offset: const Offset(-5, -5),
              blurRadius: 10,
              spreadRadius: 1,
            ),

          ],
          color: status == MatchStatus.fully
              ? moveGood
              : status == MatchStatus.contained
                  ? moveMediumAlt
                  : !enabled ? moveGrey.shade300 : Colors.white),

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
          style: TextStyle(fontSize: 30, color: moveGrey.shade800),
          maxLength: 1,
        ),
      ),
    );
  }
}


class Alphabet extends ConsumerWidget {
  const Alphabet({Key? key, required this.state}) : super(key: key);

  static const List alphabet = <String>['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','Ö','Ä','Ü'];

  final GameState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final state = ref.watch(gameProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (alphabet.length / 4).ceil(),
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0,
              ),
              itemCount: alphabet.length,
              itemBuilder: (BuildContext context, int index) {
                final status = state.alphabetMap[alphabet[index]];
                return Text(
                  alphabet[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                      color: status == MatchStatus.fully ?
                      moveGood : status == MatchStatus.contained ?
                      moveMedium : status == MatchStatus.none ?
                      moveGrey.shade500 : Colors.white,),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

