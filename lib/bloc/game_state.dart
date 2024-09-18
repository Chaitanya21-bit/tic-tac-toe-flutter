// game_state.dart
part of 'game_bloc.dart';

class GameState {
  final List<String> board;
  final bool isXNext;
  final String? winner;
  final bool isDraw;

  const GameState({
    required this.board,
    required this.isXNext,
    this.winner,
    this.isDraw = false,
  });

  factory GameState.initial() {
    return GameState(
      board: List.filled(9, ''),
      isXNext: true,
    );
  }

  GameState copyWith({
    List<String>? board,
    bool? isXNext,
    String? winner,
    bool? isDraw,
  }) {
    return GameState(
      board: board ?? this.board,
      isXNext: isXNext ?? this.isXNext,
      winner: winner,
      isDraw: isDraw ?? this.isDraw,
    );
  }
}
