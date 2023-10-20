part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class RegisterSubmitSt extends AuthState {
  final StateView stateView;

  const RegisterSubmitSt({this.stateView = const InitialStateView()});

  @override
  List<Object> get props => [stateView];
}

class LoginSubmitSt extends AuthState {
  final StateView stateView;

  const LoginSubmitSt({this.stateView = const InitialStateView()});

  @override
  List<Object> get props => [stateView];
}

class ProfileUpdateSt extends AuthState {
  final StateView stateView;

  const ProfileUpdateSt({this.stateView = const InitialStateView()});

  @override
  List<Object> get props => [stateView];
}

class UpdateFotoProfilSt extends AuthState {
  final StateView stateView;

  const UpdateFotoProfilSt({this.stateView = const InitialStateView()});

  @override
  List<Object> get props => [stateView];
}

class AuthStateMe extends AuthState {
  final StateView stateView;

  const AuthStateMe({this.stateView = const InitialStateView()});

  @override
  List<Object> get props => [stateView];
}

class PasswordUpdateSt extends AuthState {
  final StateView stateView;

  const PasswordUpdateSt({this.stateView = const InitialStateView()});

  @override
  List<Object> get props => [stateView];
}

class LogoutSt extends AuthState {
  final StateView stateView;

  const LogoutSt({this.stateView = const InitialStateView()});

  @override
  List<Object> get props => [stateView];
}
