import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/bloc/game_bloc.dart';
import 'package:tic_tac_toe/core/app_colors.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.black,
          centerTitle: true,
          title: const Text(
            'TicTacToe Game',
            style: TextStyle(color: AppColors.white),
          ),
        ),
        body: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            return ColoredBox(
              color: AppColors.black,
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: 9,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            if (state.board[index] == '' &&
                                state.winner == null &&
                                !state.isDraw) {
                              context.read<GameBloc>().playerMove(index);
                            }
                          },
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(8),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColors.containerGrey,
                                border: Border.all(
                                  width: 3,
                                ),
                                borderRadius:
                                    BorderRadius.circular(8), // Rounded corners
                              ),
                              child: Center(
                                child: Text(
                                  state.board[index],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 40,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (state.winner != null)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Winner: ${state.winner}',
                        style: const TextStyle(
                          fontSize: 24,
                          color: AppColors.white,
                        ),
                      ),
                    )
                  else if (state.isDraw)
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "It's a draw!",
                        style: TextStyle(fontSize: 24, color: AppColors.white),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white, // Background color
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Rounded corners
                        ),
                        elevation: 8, // Shadow effect
                      ),
                      onPressed: () {
                        context.read<GameBloc>().resetGame();
                      },
                      child: const Text(
                        'Reset Game',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
