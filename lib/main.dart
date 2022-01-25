import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_app/app.dart';
import 'package:market_app/simple_bloc_observer.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(App()),
    blocObserver: SimpleBlocObserver(),
  );
}
