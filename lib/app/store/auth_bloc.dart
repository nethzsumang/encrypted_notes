import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthEvent {}
class UsernameChanged extends AuthEvent {
  String data;

  UsernameChanged(this.data);
}
class PasswordChanged extends AuthEvent {
  String data;

  PasswordChanged(this.data);
}

class AuthBloc extends Bloc<AuthEvent, Map> {
  AuthBloc() : super({
    'username': '',
    'password': ''
  }) {
    on<UsernameChanged>((event, emit) {
      Map newCredentials = Map.from(state);
      newCredentials['username'] = event.data;
      emit(newCredentials);
    });

    on<PasswordChanged>((event, emit) {
      Map newCredentials = Map.from(state);
      newCredentials['password'] = event.data;
      emit(newCredentials);
    });
  }
}