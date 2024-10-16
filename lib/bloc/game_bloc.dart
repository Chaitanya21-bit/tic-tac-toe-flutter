import 'package:flutter_bloc/flutter_bloc.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameState.initial()) {
    on<PlayerMove>(_onPlayerMove);
    on<ResetGame>(_onResetGame);
  }

  void _onPlayerMove(PlayerMove event, Emitter<GameState> emit) {
    final currentState = state;

    if (currentState.winner != null ||
        currentState.board[event.index] != '' ||
        currentState.isDraw) {
      return;
    }

    final newBoard = List<String>.from(currentState.board);
    newBoard[event.index] = currentState.isXNext ? 'X' : 'O';

    final winnerResult = _checkWinner(newBoard);
    final String? winner = winnerResult['winner'] as String?;
    final List<int>? winningIndices =
        winnerResult['winningIndices'] as List<int>?;

    final isDraw = !newBoard.contains('') && winner == null;

    emit(
      currentState.copyWith(
        board: newBoard,
        isXNext: !currentState.isXNext,
        winner: winner,
        isDraw: isDraw,
        winningIndices: winningIndices,
      ),
    );
  }

  void _onResetGame(ResetGame event, Emitter<GameState> emit) {
    emit(GameState.initial());
  }

  Map<String, dynamic> _checkWinner(List<String> board) {
    const List<List<int>> winningPositions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];

    for (final positions in winningPositions) {
      final a = board[positions[0]];
      final b = board[positions[1]];
      final c = board[positions[2]];

      if (a == b && b == c && a.isNotEmpty) {
        return {
          'winner': a,
          'winningIndices': positions,
        };
      }
    }

    return {
      'winner': null,
      'winningIndices': null,
    };
  }

  void playerMove(int index) {
    add(PlayerMove(index));
  }

  void resetGame() {
    add(ResetGame());
  }
}
