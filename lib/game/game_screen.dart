import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:word_salad/game/game_state.dart';
import 'package:word_salad/game/game_provider.dart';

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
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            height: 800,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'FLUTTER WORDLE',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Center(
                    child: SizedBox(
                        height: 600,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            color: Colors.white,
                            elevation: 10,
                            child: TextFields(
                              trials: state.trials,
                              attempt: state.attempt,
                              wordLength: state.wordLength,
                              solution: word,
                            ),
                          ),
                        )),
                  ),
                ],
              ),
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

  List<List<TextEditingController>> _getGridController(int cols, int rows) {
    final controllerArray = List.generate(
        rows,
        (i) => List.generate(cols + 1, (_) => TextEditingController(),
            growable: false),
        growable: false);
    return controllerArray;
  }

  void _submit(int index) {
    ref.read(gameProvider.notifier).setWord(widget.solution);
    final charList = <String>[];
    for (var element in _gridController[index]) {
      charList.add(element.text);
    }
    final guess = charList.join('').trim();
    ref.read(gameProvider.notifier).submit({index: guess});
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameProvider);
    debugPrint(state.validation.toString());

    final focus = FocusNode();

    return Padding(
      padding: const EdgeInsets.all(8.0),
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
            padding: const EdgeInsets.only(bottom: 15),
            child: ElevatedButton(
              onPressed: () => _submit(state.attempt),
              child: const Text('Go'),
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
      required this.status})
      : super(key: key);

  final MatchStatus status;
  final bool enabled;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: status == MatchStatus.fully
              ? Colors.blue
              : status == MatchStatus.contained
                  ? Colors.orange
                  : Colors.white),
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
          style: const TextStyle(fontSize: 30, color: Colors.black),
          maxLength: 1,
        ),
      ),
    );
  }
}
