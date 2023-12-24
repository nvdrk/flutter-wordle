import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_wordle/data/api.dart';

import 'game_state.dart';

final wordProvider = FutureProvider.autoDispose<String>((ref) async {
  return ref.read(Dependency.wordRepository).getRandomWord(5);
});

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier()
      : super(const GameState(
            solution: '',
            colIndex: 0,
            trials: 6,
            attempt: 0,
            submittedAttempt: {},
            wordLength: 5,
            validation: [],
            alphabetMap: {},
  ));

  void setWord(String word) {
    state = state.copyWith(solution: word);
  }

  void updateColIndex(int colIndex) {
    if (colIndex == state.wordLength || colIndex < 0) {
      return;
    }
    state = state.copyWith(colIndex: colIndex);
  }

  Map<Validation, Map<String, MatchStatus>> _validate(String guess, int row) {

    final validation = Validation(rowIndex: row, validated: {});
    final Map<String, MatchStatus> alphabetMap = {};

    final indexesOfFullMatches = <int>[];
    final indexesOfPartialMatches = <int>[];

    final guessCharList = guess.split('').map((e) => e.toUpperCase()).toList();
    final solutionCharList =
    state.solution.split('').map((e) => e.toUpperCase()).toList();


    for (int i = 0; i < guessCharList.length; i++) {
      if (guessCharList[i] == solutionCharList[i]) {
        indexesOfFullMatches.add(i);
      }
    }

    for (int i = 0; i < guessCharList.length; i++) {
      if (solutionCharList.contains(guessCharList[i])) {
        indexesOfPartialMatches.add(i);
      }
    }

    for (int i = 0; i < guessCharList.length; i++) {

      final charWithMatch = CharWithMatch();

      final element = guessCharList[i];
      final solutionIndex = solutionCharList.indexOf(element);

      if (solutionIndex == -1) {
        charWithMatch.char = element;
        charWithMatch.matchStatus = MatchStatus.none;

      } else if (element == solutionCharList[i]) {
        charWithMatch.char = element;
        charWithMatch.matchStatus = MatchStatus.fully;

      } else if (solutionCharList.contains(element)) {

        final elementCount = solutionCharList.where((char) => char == element).toList().length;
        final elementCountPartial = guessCharList.where((char) => char == element).toList().length;

        final overCount = elementCountPartial - elementCount;

        for (int i = overCount; i > 1; i--) {
          indexesOfPartialMatches.removeWhere((index) => guessCharList[index] == element);
        }

        indexesOfPartialMatches
            .removeWhere((element) => indexesOfFullMatches.contains(element));

        if (indexesOfPartialMatches.contains(guessCharList.indexOf(element))) {
          charWithMatch.char = element;
          charWithMatch.matchStatus = MatchStatus.contained;
        } else {
          charWithMatch.char = element;
          charWithMatch.matchStatus = MatchStatus.none;
        }
      } else {
        charWithMatch.char = element;
        charWithMatch.matchStatus = MatchStatus.none;
      }
      validation.validated?.addAll({i: charWithMatch});
      alphabetMap.addAll({charWithMatch.char! : charWithMatch.matchStatus!});
    }
    return {validation : alphabetMap};
  }

  void submit(Map<int, String> userSolution) {
    final currentSubmissions = Map.of(state.submittedAttempt);
    currentSubmissions.addAll(userSolution);
    final validations = List.of(state.validation);
    final alphabetMap = Map.of(state.alphabetMap);
    final validated = _validate(userSolution.values.first, userSolution.keys.first);
    validations
        .add(validated.keys.first);
    alphabetMap.addAll(validated.values.first);

    debugPrint(state.validation.toString());

    state = state.copyWith(
        submittedAttempt: currentSubmissions,
        attempt: userSolution.keys.first + 1,
        validation: validations,
        alphabetMap: alphabetMap,
        colIndex: 0,
    );
  }
}
