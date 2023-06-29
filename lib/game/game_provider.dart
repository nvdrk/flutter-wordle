import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:word_salad/data/api.dart';

import 'game_state.dart';



final wordProvider = FutureProvider.autoDispose<String>((ref) async {
  return ref.watch(Dependency.wordRepository).getRandomWord(5);
});


final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});


class GameNotifier extends StateNotifier<GameState> {
  GameNotifier(): super(const GameState(solution: '', trials: 6, attempt: 0, submittedAttempt: {}, wordLength: 5, validation: []));

  void setWord(String word) {
    state = state.copyWith(solution: word);
  }

  Validation _validate(String guess, int row) {

    final validation = Validation(rowIndex: row, validated: {});

    final indexOfFullMatches = <int>[];
    final indexesOfPartialMatches = <int>[];

    final guessCharList = guess.split('').map((e) => e.toUpperCase()).toList();
    final solutionCharList = state.solution.split('').map((e) => e.toUpperCase()).toList();


    for (int i = 0; i < guessCharList.length; i++) {
      if (guessCharList[i] == solutionCharList[i]) {
        indexOfFullMatches.add(i);
      }
    }

    for (int i = 0; i < guessCharList.length; i++) {
      if (solutionCharList.contains(guessCharList[i])) {
        indexesOfPartialMatches.add(i);
      }
    }

    for (int i = 0; i < guessCharList.length; i++) {

      debugPrint(i.toString());

      final charWithMatch = CharWithMatch();

      var element = guessCharList[i];
      var solutionIndex = solutionCharList.indexOf(element);

      debugPrint(solutionCharList.toString());

      if (solutionIndex == -1) {

        charWithMatch.char = element;
        charWithMatch.matchStatus = MatchStatus.none;
      }
      else if (element == solutionCharList[i]) {

        charWithMatch.char = element;
        charWithMatch.matchStatus = MatchStatus.fully;

      } else if (solutionCharList.contains(element)) {

        indexesOfPartialMatches.removeWhere((element) => indexOfFullMatches.contains(element));

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
      validation.validated!.addAll({i: charWithMatch});
    }
    return validation;

  }


  void submit(Map<int, String> userSolution) {

    var currentSubmissions = Map.of(state.submittedAttempt);
    currentSubmissions.addAll(userSolution);
    final validations = List.of(state.validation);
    validations.add(_validate(userSolution.values.first, userSolution.keys.first));

    state = state.copyWith(submittedAttempt: currentSubmissions, attempt: userSolution.keys.first + 1, validation: validations);
    if (userSolution.values.first == state.solution) {

    }
  }
}