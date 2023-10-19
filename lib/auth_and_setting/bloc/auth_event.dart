part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class RegisterSubmitEv extends AuthEvent {
  final String namaLengkap;
  final String namaPanggilan;
  final String email;
  final String password;

  const RegisterSubmitEv({
    this.namaLengkap = '',
    this.namaPanggilan = '',
    this.email = '',
    this.password = '',
  });

  @override
  List<Object> get props => [namaLengkap, namaPanggilan, email, password];
}

class LoginSubmitEv extends AuthEvent {
  final String email, password;

  const LoginSubmitEv({this.email = '', this.password = ''});

  @override
  List<Object> get props => [email, password];
}

class MeEv extends AuthEvent {
  @override
  List<Object> get props => [];
}

class PasswordUpdateEv extends AuthEvent {
  final String passwordLama, passwordBaru, passwordConfirm;

  const PasswordUpdateEv({
    this.passwordLama = '',
    this.passwordBaru = '',
    this.passwordConfirm = '',
  });

  @override
  List<Object> get props => [passwordLama, passwordBaru, passwordConfirm];
}

class ProfileUpdateEv extends AuthEvent {
  final String namaLengkap;
  final String namaPanggilan;
  final String email;
  final String password;

  const ProfileUpdateEv({
    this.namaLengkap = '',
    this.namaPanggilan = '',
    this.email = '',
    this.password = '',
  });

  @override
  List<Object> get props => [namaLengkap, namaPanggilan, email, password];
}

class UpdateFotoUserEv extends AuthEvent {
  final int idRelawan;
  final File? gambarUser;

  const UpdateFotoUserEv({required this.idRelawan, this.gambarUser});
  @override
  List<Object> get props => [idRelawan];
}

class LogoutEv extends AuthEvent {}
