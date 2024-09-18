import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

B getBloc<B>(
  BuildContext context,
) =>
    context.read<B>();
