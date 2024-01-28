import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_wordle/data/api.dart';

import 'game_state.dart';

final wordProvider = FutureProvider.autoDispose<String>((ref) async {
  return ref.read(Dependency.wordRepository).getRandomWord(5);
});

final gameProvider = NotifierProvider<GameNotifier, GameState>((GameNotifier.new));

class GameNotifier extends Notifier<GameState> {
  void setWord(String word) {
    state = state.copyWith(solution: word.toUpperCase());
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
    final List<bool> solutionCharsTaken =
        List.generate(state.solution.length, (index) => false);

    final indexesOfFullMatches = <int>[];
    final indexesOfPartialMatches = <int>[];

    final guessCharList = guess.split('').map((e) => e.toUpperCase()).toList();
    final solutionCharList =
        state.solution.split('').map((e) => e.toUpperCase()).toList();

    // Match fully
    for (int i = 0; i < guessCharList.length; i++) {
      if (guessCharList[i] == solutionCharList[i]) {
        indexesOfFullMatches.add(i);
        solutionCharsTaken[i] = true;
      }
    }

    // Match partially
    for (int i = 0; i < guessCharList.length; i++) {
      if (!indexesOfFullMatches.contains(i) && !solutionCharsTaken[i]) {
        final element = guessCharList[i];
        // Search for the character in the remaining untaken characters of the solution
        int solutionIndex = solutionCharList.indexOf(element);
        while (solutionIndex != -1 && solutionCharsTaken[solutionIndex]) {
          solutionIndex = solutionCharList.indexOf(element, solutionIndex + 1);
        }

        if (solutionIndex != -1) {
          indexesOfPartialMatches.add(i);
          solutionCharsTaken[solutionIndex] = true;
        }
      }
    }

    for (int i = 0; i < guessCharList.length; i++) {
      final charWithMatch = CharWithMatch();
      final element = guessCharList[i];

      if (indexesOfFullMatches.contains(i)) {
        charWithMatch.char = element;
        charWithMatch.matchStatus = MatchStatus.fully;
      } else if (indexesOfPartialMatches.contains(i)) {
        charWithMatch.char = element;
        charWithMatch.matchStatus = MatchStatus.contained;
      } else {
        charWithMatch.char = element;
        charWithMatch.matchStatus = MatchStatus.none;
      }
      validation.validated?.addAll({i: charWithMatch});
      alphabetMap.addAll({charWithMatch.char!: charWithMatch.matchStatus!});
    }

    return {validation: alphabetMap};
  }

  void submit(Map<int, String> userSolution) {
    final currentSubmissions = Map.of(state.submittedAttempt);
    currentSubmissions.addAll(userSolution);
    final validations = List.of(state.validation);
    final alphabetMap = Map.of(state.alphabetMap);
    final validated =
        _validate(userSolution.values.first, userSolution.keys.first);
    validations.add(validated.keys.first);
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

  @override
  GameState build() {
    return const GameState(
      solution: '',
      colIndex: 0,
      trials: 6,
      attempt: 0,
      submittedAttempt: {},
      wordLength: 5,
      validation: [],
      alphabetMap: {},
    );
  }
}
