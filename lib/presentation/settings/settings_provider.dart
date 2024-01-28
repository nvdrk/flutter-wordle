import 'package:flutter_wordle/presentation/settings/settings_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});

class SettingsNotifier extends Notifier<SettingsState> {

  void setWordLength(int length) {
    state = state.copyWith(wordLength: length);
  }

  void setTrials(int trials) {
    state = state.copyWith(trials: trials);
  }

  void setLanguage(String languageCode) {
    state = state.copyWith(languageCode: languageCode);
  }

  @override
  SettingsState build() {
    return const SettingsState(
      trials: 6,
      wordLength: 5,
      languageCode: 'en',
    );
  }
}
