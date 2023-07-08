import 'package:flutter_wordle/settings/settings_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier()
      : super(const SettingsState(
          trials: 6,
          wordLength: 5,
          languageCode: 'en',
        ));

  void setWordLength(int length) {
    state = state.copyWith(wordLength: length);
  }

  void setTrials(int trials) {
    state = state.copyWith(trials: trials);
  }

  void setLanguage(String languageCode) {
    state = state.copyWith(languageCode: languageCode);
  }
}
