import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:flutter_wordle/components/neumorphic_button.dart';
import 'package:flutter_wordle/layouts/loading_layout.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_wordle/components/appbar.dart';
import 'package:flutter_wordle/game/game_state.dart';
import 'package:flutter_wordle/game/game_provider.dart';
import 'package:flutter_wordle/theme/style.dart';
import 'package:flutter_wordle/components/neumphorphic_textfield.dart';

class GameLayout extends ConsumerWidget {
  const GameLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(wordProvider);
    return value.when(
      data: (value) => GameScreen(word: value),
      error: ErrorLayout.new,
      loading: () => const LoadingLayout(),
    );
  }
}

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key, required this.word});

  final String word;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameProvider);

    return Scaffold(
      backgroundColor: greyTint.shade200,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomAppBar(
          title: 'Word Hamster',
          isPop: true,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          child: SizedBox(
              height: 800,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFields(
                  trials: state.trials,
                  attempt: state.attempt,
                  wordLength: state.wordLength,
                  solution: word,
                ),
              )),
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
    ref.read(gameProvider.notifier)
      ..submit({index: guess})
    ..updateColIndex(0);

    final state = ref.watch(gameProvider);
    if (state.trials == state.attempt) {
      _showAlertDialog();
    }
  }

  Future<void> _showAlertDialog() async {
    final solution = ref.read(gameProvider).solution;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sorry :('),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(' No Luck this time'
                    'The Solution is: \n'
                    '$solution'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Go Back'),
              onPressed: () {
                ref.invalidate(gameProvider);
                context.go('/');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Flexible(
            flex: 2,
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

                return NeumorphicTextFormField(
                  node: FocusNode(),
                  index: colIndex,
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
          Flexible(
            flex: 1,
            child: SizedBox(
              height: 200,
              child: Card(
                color: greyTint.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Alphabet(gridController: _gridController),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: NeumorphicButton(
              onTap: () => _submit(state.attempt),
              title: 'SUBMIT',
              height: 50,
              width: 200, isToggle: false, hasHapticFeedBack: false,
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



class Alphabet extends ConsumerWidget {
  const Alphabet({Key? key, required this.gridController}) : super(key: key);

  final List<List<TextEditingController>> gridController;

  static const List alphabet = <String>[
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
    'Ö',
    'Ä',
    'Ü',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameProvider);
    final notifier = ref.read(gameProvider.notifier);

    return Column(
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
            itemCount: alphabet.length + 1,
            itemBuilder: (BuildContext context, int index) {
              MatchStatus? status;
              if (index <= alphabet.length - 1) {
                status = state.alphabetMap[alphabet[index]];
              }
              return InkWell(
                onTap: () {
                  gridController[state.attempt][state.colIndex].text = alphabet[index];
                  notifier.updateColIndex(state.colIndex + 1);
                },
                child: index == alphabet.length ? SizedBox(
                  height: 50,
                  width: 50,
                  child: IconButton(
                      color: Colors.black,
                      onPressed: () {
                        gridController[state.attempt][state.colIndex].text = '';
                        notifier.updateColIndex(state.colIndex -1);
                      },
                      icon: const Icon(Icons.backspace_outlined)),
                )
                    : Text(
                  alphabet[index],
                  textAlign: TextAlign.center,
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
                    fontSize: 25,
                    color: status == MatchStatus.fully
                        ? good
                        : status == MatchStatus.contained
                        ? medium
                        : status == MatchStatus.none
                        ? greyTint.shade800
                        : greyTint.shade500,
                  ),
                ),
              );
            },
          ),
        ),

      ],
    );
  }
}