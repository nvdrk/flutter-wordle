import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.trials,
    required this.wordLength,
    required this.languageCode,
  });

  final int wordLength;
  final int trials;
  final String languageCode;

  @override
  List<Object?> get props => [trials, wordLength, languageCode];

  SettingsState copyWith({
    int? trials,
    int? wordLength,
    String? languageCode,
  }) {
    return SettingsState(
      trials: trials ?? this.trials,
      wordLength: wordLength ?? this.wordLength,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}
