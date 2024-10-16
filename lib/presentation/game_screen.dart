import 'dart:async'; // Import Timer

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/bloc/game_bloc.dart';
import 'package:tic_tac_toe/core/app_colors.dart';
import 'package:tic_tac_toe/utils/bloc_utils.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double _scaleFactor = 1; // Scale factor for tiles
  Timer? _timer; // Timer to control the scale down

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer on dispose
    super.dispose();
  }

  void _startWinningAnimation() {
    setState(() {
      _scaleFactor = 1.2; // Scale up when there is a winner
    });

    // Start a timer to scale down after 1 second
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _scaleFactor = 1.0; // Scale down after 1 second
        });
      }
    });
  }

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
        body: BlocListener<GameBloc, GameState>(
          listener: (context, state) {
            // Check if there's a winner and start the animation
            if (state.winner != null && state.winningIndices != null) {
              _startWinningAnimation();
            }
          },
          child: BlocBuilder<GameBloc, GameState>(
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
                          // Check if the current index is part of the winning combination
                          final bool isWinningIndex =
                              state.winningIndices?.contains(index) ?? false;

                          return GestureDetector(
                            onTap: () {
                              if (state.board[index] == '' &&
                                  state.winner == null &&
                                  !state.isDraw) {
                                getBloc<GameBloc>(context: context)
                                    .playerMove(index);
                              }
                            },
                            child: AnimatedScale(
                              scale: isWinningIndex
                                  ? _scaleFactor
                                  : 1.0, // Use the scale factor
                              duration: const Duration(
                                milliseconds: 300,
                              ), // Animation duration
                              curve: Curves.easeInOut, // Smooth animation curve
                              child: Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(8),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: isWinningIndex
                                        ? AppColors
                                            .winningColor // Color for winning indices
                                        : AppColors
                                            .containerGrey, // Normal color
                                    border: Border.all(
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ), // Rounded corners
                                  ),
                                  child: Center(
                                    child: Text(
                                      state.board[index],
                                      style: const TextStyle(
                                        color: AppColors
                                            .black, // Normal text color
                                        fontSize: 40,
                                      ),
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
                          style:
                              TextStyle(fontSize: 24, color: AppColors.white),
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
                          getBloc<GameBloc>(context: context).resetGame();
                          setState(() {
                            _scaleFactor = 1.0; // Reset scale when game resets
                          });
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
      ),
    );
  }
}
