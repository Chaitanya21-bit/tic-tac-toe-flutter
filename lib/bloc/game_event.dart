part of 'game_bloc.dart';

abstract class GameEvent {}

class PlayerMove extends GameEvent {
  final int index;

  PlayerMove(this.index);
}

class ResetGame extends GameEvent {}
