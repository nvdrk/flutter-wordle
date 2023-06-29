import 'package:equatable/equatable.dart';

class GameState extends Equatable {

  const GameState({
    required this.solution,
    required this.trials,
    required this.attempt,
    required this.wordLength,
    required this.submittedAttempt,
    required this.validation});

  final String solution;
  final int trials;
  final int attempt;
  final int wordLength;
  final Map<int, String> submittedAttempt;
  final List<Validation> validation;

  @override
  List<Object?> get props => [solution, trials, attempt, submittedAttempt];


  GameState copyWith({
    String? solution,
    int? trials, int? attempt,
    int? wordLength,
    Map<int, String>? submittedAttempt,
    List<Validation>? validation}) {
    return GameState(
      solution: solution ?? this.solution,
      trials: trials ?? this.trials,
      attempt: attempt ?? this.attempt,
      wordLength: wordLength ?? this.wordLength,
      submittedAttempt: submittedAttempt ?? this.submittedAttempt,
      validation: validation ?? this.validation,
    );
  }
}

typedef ValidatedIndex = Map<int, CharWithMatch>;

class Validation {

  Validation({required this.rowIndex, this.validated});

  final int rowIndex;
  final ValidatedIndex? validated;

  MatchStatus? getMatchStatus(int colIndex) {
    return validated?.entries.where((element) => element.key == colIndex).map((e) => e.value.matchStatus).first as MatchStatus;
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
  none,
  contained,
  fully,
}