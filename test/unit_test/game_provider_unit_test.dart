import 'package:flutter_wordle/data/api.dart';
import 'package:flutter_wordle/game/game_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wordle/game/game_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockDependency extends Mock implements Dependency {}

void main() {
  test('Setting a word should update the state', () async {

    final container = ProviderContainer();

    expect(
      container.read(wordProvider),
      const AsyncValue<String>.loading(),
    );


    final gameNotifier = GameNotifier();
    gameNotifier.setWord('PASTE');

    expect(gameNotifier.state.solution, 'PASTE');

  });

  test('Submitting a solution should update the state', () {

    final gameNotifier = GameNotifier();

    gameNotifier.setWord('PASTE');
    gameNotifier.submit({0: 'PASTA'});

    final validation = {
          0: CharWithMatch(char: 'P', matchStatus: MatchStatus.fully),
          1: CharWithMatch(char: 'A', matchStatus: MatchStatus.fully),
          2: CharWithMatch(char: 'S', matchStatus: MatchStatus.fully),
          3: CharWithMatch(char: 'T', matchStatus: MatchStatus.fully),
          4: CharWithMatch(char: 'A', matchStatus: MatchStatus.none),
    };


    expect(gameNotifier.state.attempt, 1);
    expect(gameNotifier.state.validation, [isA<Validation>()
      .having((v) => v.validated, 'validated', Validation(rowIndex: 0, validated: validation))
    ]);


  });
}
