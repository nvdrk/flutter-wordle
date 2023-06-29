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
        body: SingleChildScrollView(
          child: SizedBox(
            height: 800,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Word Salad'),
                  Center(
                    child: SizedBox(
                      height: 700,
                      child: TextFields(
                        trials: state.trials,
                        attempt: state.attempt,
                        wordLength: state.wordLength,
                        solution: word,
                      )
                    ),
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
  const TextFields({Key? key, required this.trials, required this.attempt, required this.wordLength, required this.solution,}) : super(key: key);

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
    _gridController = _getGridController(widget.trials, widget.trials);
  }

  List<List<TextEditingController>> _getGridController(int cols, int rows) {
    final controllerArray = List.generate(rows,
            (i) => List.generate(cols + 1, (_) => TextEditingController(), growable: false),
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

    return Column(
      children: [
        Flexible(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.trials,
            itemBuilder: (BuildContext context, int indexRow) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.wordLength,
                      itemBuilder: (BuildContext context, int indexCol) {
                    return CustomTextFormField(
                      enabled: (indexRow == state.attempt),
                      status: (state.validation.length > indexRow) ? state.validation.where((element) => element.rowIndex == indexRow).first.getMatchStatus(indexCol) ?? MatchStatus.none : MatchStatus.none,
                      controller: _gridController[indexRow][indexCol],
                    );
                  }),
                ),
              );
          },
          ),
        ),
        ElevatedButton(
            onPressed: () => _submit(state.attempt),
            child: const Text('Go'))
      ],
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
  const CustomTextFormField({Key? key, required this.controller, required this.enabled, required this.status}) : super(key: key);

  final MatchStatus status;
  final bool enabled;
  final TextEditingController controller;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: status == MatchStatus.fully ? Colors.blue : status == MatchStatus.contained ? Colors.orange : Colors.white
        ),
        child: TextFormField(
          controller: controller,
          enabled: enabled,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(semanticCounterText: null, border: InputBorder.none, counter: null, counterText: '',),
          textAlign: TextAlign.center,
          textCapitalization: TextCapitalization.characters,
          style: const TextStyle(fontSize: 30, color: Colors.black),
          maxLength: 1,
        ),
      ),
    );
  }
}
