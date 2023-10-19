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

  AuthStateMe copyWith({StateView? stateView}) {
    return AuthStateMe(stateView: stateView ?? this.stateView);
  }

  @override
  List<Object> get props => [stateView];
}

class AuthPassChangeSt extends AuthState {
  final StateView stateView;

  const AuthPassChangeSt({this.stateView = const InitialStateView()});

  @override
  List<Object> get props => [stateView];
}

class AuthStateLogout extends AuthState {
  final StateView stateView;

  const AuthStateLogout({this.stateView = const InitialStateView()});

  @override
  List<Object> get props => [stateView];
}
