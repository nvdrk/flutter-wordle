import 'package:equatable/equatable.dart';

class GameState extends Equatable {
  const GameState(
      {required this.solution,
      required this.colIndex,
      required this.trials,
      required this.attempt,
      required this.wordLength,
      required this.submittedAttempt,
      required this.validation,
      required this.alphabetMap,
      });

  final String solution;
  final int colIndex;
  final int trials;
  final int attempt;
  final int wordLength;
  final Map<int, String> submittedAttempt;
  final List<Validation> validation;
  final Map<String, MatchStatus> alphabetMap;

  @override
  List<Object?> get props => [solution, trials, attempt, submittedAttempt];

  GameState copyWith(
      {String? solution,
      int? colIndex,
      int? trials,
      int? attempt,
      int? wordLength,
      Map<int, String>? submittedAttempt,
      List<Validation>? validation,
      Map<String, MatchStatus>? alphabetMap,
      }) {
    return GameState(
      solution: solution ?? this.solution,
      colIndex: colIndex ?? this.colIndex,
      trials: trials ?? this.trials,
      attempt: attempt ?? this.attempt,
      wordLength: wordLength ?? this.wordLength,
      submittedAttempt: submittedAttempt ?? this.submittedAttempt,
      validation: validation ?? this.validation,
      alphabetMap: alphabetMap ?? this.alphabetMap,
    );
  }
}

typedef ValidatedCharIndexed = Map<int, CharWithMatch>;

class Validation {
  Validation({required this.rowIndex, this.validated});

  final int rowIndex;
  final ValidatedCharIndexed? validated;

  MatchStatus? getMatchStatus(int colIndex) {
    return validated?.entries
        .where((element) => element.key == colIndex)
        .map((e) => e.value.matchStatus)
        .first as MatchStatus;
  }

  @override
  String toString() {
    return "rowIndex: $rowIndex, val: $validated";
  }
}

class CharWithMatch {
  CharWithMatch({this.char, this.matchStatus});

  String? char;
  MatchStatus? matchStatus;

  @override
  String toString() {
    return '$char : $matchStatus';
  }
}

enum MatchStatus {
  unknown,
  none,
  contained,
  fully,
}
