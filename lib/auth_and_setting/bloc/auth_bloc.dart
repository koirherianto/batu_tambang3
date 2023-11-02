import 'dart:io';

import 'package:batu_tambang/auth_and_setting/services/auth_api.dart';
import 'package:batu_tambang/auth_and_setting/services/me_prefrences.dart';
import 'package:batu_tambang/auth_and_setting/services/token_service.dart';
import 'package:batu_tambang/static_data/connection.dart';
import 'package:batu_tambang/static_data/state_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthApi authApi;
  // // final Database database;
  final MePrefrences mePrefrences;
  final TokenService tokenService;
  final ConnectionService connectionService;
  AuthBloc({
    required this.authApi,
    required this.mePrefrences,
    required this.tokenService,
    required this.connectionService,
  }) : super(const AuthState()) {
    on<RegisterSubmitEv>((event, emit) async {
      emit(const RegisterSubmitSt(stateView: LoadingStateView()));

      bool isOfline = await connectionService.isOfline();
      if (isOfline) {
        emit(const RegisterSubmitSt(stateView: OflineStateView()));
        await Future.delayed(const Duration(seconds: 1));
        emit(const RegisterSubmitSt(stateView: InitialStateView()));
        return;
      }

      Map<String, dynamic> response = await authApi.registerApi(
        email: event.email,
        namaLengkap: event.namaLengkap,
        namaPanggilan: event.namaPanggilan,
        password: event.password,
      );

      if (response['success'] == true) {
        emit(const RegisterSubmitSt(stateView: SuccessStateView()));
      }

      if (response['success'] == false) {
        final Map<String, dynamic> errorMap = response["error"] ?? {};
        if (errorMap.isNotEmpty) {
          emit(RegisterSubmitSt(stateView: FailedStateView(errMsg: errorMap)));
        }

        final Map<String, dynamic> exeption = response["exeption"] ?? {};
        if (exeption.isNotEmpty) {
          emit(RegisterSubmitSt(stateView: FailedStateView(errMsg: exeption)));
        }

        final Map<String, dynamic> unAuth = response["unauthenticated"] ?? {};
        if (unAuth.isNotEmpty) {
          emit(const RegisterSubmitSt(stateView: UnauthenticatedStateView()));
        }
      }

      await Future.delayed(const Duration(seconds: 1));
      emit(const RegisterSubmitSt(stateView: InitialStateView()));
    });

    on<LoginSubmitEv>((event, emit) async {
      emit(const LoginSubmitSt(stateView: LoadingStateView()));

      bool isOfline = await connectionService.isOfline();
      if (isOfline) {
        emit(const LoginSubmitSt(stateView: OflineStateView()));
        await Future.delayed(const Duration(seconds: 1));
        emit(const LoginSubmitSt(stateView: InitialStateView()));
        return;
      }

      Map<String, dynamic> response = await authApi.loginApi(
        email: event.email,
        password: event.password,
      );

      if (response['success'] == true) {
        Map<String, dynamic> dataUser = response['data']['user'];
        await mePrefrences.setMe(
          id: dataUser['id'] ?? 0,
          namaLengkap: dataUser['nama_lengkap'] ?? '',
          namaPanggilan: dataUser['nama_panggilan'] ?? '',
          email: dataUser['email'] ?? '',
          role: dataUser['role'] ?? '',
          urlProfil: dataUser['url_profil'] ?? '',
        );
        await tokenService.setLocalToken(response['data']['token']);
        emit(const LoginSubmitSt(stateView: SuccessStateView()));
      }

      if (response['success'] == false) {
        final Map<String, dynamic> errorMap = response["error"] ?? {};
        if (errorMap.isNotEmpty) {
          emit(LoginSubmitSt(stateView: FailedStateView(errMsg: errorMap)));
        }

        final Map<String, dynamic> exeption = response["exeption"] ?? {};
        if (exeption.isNotEmpty) {
          emit(LoginSubmitSt(stateView: FailedStateView(errMsg: exeption)));
        }

        final Map<String, dynamic> unAuth = response["unauthenticated"] ?? {};
        if (unAuth.isNotEmpty) {
          emit(const LoginSubmitSt(stateView: UnauthenticatedStateView()));
        }
      }

      await Future.delayed(const Duration(seconds: 1));
      emit(const LoginSubmitSt(stateView: InitialStateView()));
    });

    on<ProfileUpdateEv>((event, emit) async {
      emit(const ProfileUpdateSt(stateView: LoadingStateView()));

      bool isOfline = await connectionService.isOfline();
      if (isOfline) {
        emit(const ProfileUpdateSt(stateView: OflineStateView()));
        await Future.delayed(const Duration(seconds: 1));
        emit(const ProfileUpdateSt(stateView: InitialStateView()));
        return;
      }

      Map<String, dynamic> response = await authApi.updateProfile(
        email: event.email,
        namaLengkap: event.namaLengkap,
        namaPanggilan: event.namaPanggilan,
        tokenService: tokenService,
      );

      if (response['success'] == true) {
        Map<String, dynamic> dataUser = response['data']['user'];
        await mePrefrences.setMe(
          id: dataUser['id'] ?? 0,
          namaLengkap: dataUser['nama_lengkap'] ?? '',
          namaPanggilan: dataUser['nama_panggilan'] ?? '',
          email: dataUser['email'] ?? '',
          role: dataUser['role'] ?? '',
          urlProfil: dataUser['url_profil'] ?? '',
        );
        emit(ProfileUpdateSt(stateView: SuccessStateView(data: response)));
      }

      if (response['success'] == false) {
        final Map<String, dynamic> errorMap = response["error"] ?? {};
        if (errorMap.isNotEmpty) {
          emit(ProfileUpdateSt(stateView: FailedStateView(errMsg: errorMap)));
        }

        final Map<String, dynamic> exeption = response["exeption"] ?? {};
        if (exeption.isNotEmpty) {
          emit(ProfileUpdateSt(stateView: FailedStateView(errMsg: exeption)));
        }

        final Map<String, dynamic> unAuth = response["unauthenticated"] ?? {};
        if (unAuth.isNotEmpty) {
          emit(const ProfileUpdateSt(stateView: UnauthenticatedStateView()));
        }
      }

      await Future.delayed(const Duration(seconds: 1));
      emit(const ProfileUpdateSt(stateView: InitialStateView()));
    });

    on<PasswordUpdateEv>((event, emit) async {
      emit(const PasswordUpdateSt(stateView: LoadingStateView()));

      bool isOfline = await connectionService.isOfline();
      if (isOfline) {
        emit(const PasswordUpdateSt(stateView: OflineStateView()));
        await Future.delayed(const Duration(seconds: 1));
        emit(const PasswordUpdateSt(stateView: InitialStateView()));
        return;
      }

      Map<String, dynamic> response = await authApi.updatePassword(
        passLama: event.passwordLama,
        passBaru: event.passwordBaru,
        passConfirm: event.passwordConfirm,
        tokenService: tokenService,
      );

      if (response['success'] == true) {
        emit(PasswordUpdateSt(stateView: SuccessStateView(data: response)));
      }

      if (response['success'] == false) {
        final Map<String, dynamic> errorMap = response["error"] ?? {};
        if (errorMap.isNotEmpty) {
          emit(PasswordUpdateSt(stateView: FailedStateView(errMsg: errorMap)));
        }

        final Map<String, dynamic> exeption = response["exeption"] ?? {};
        if (exeption.isNotEmpty) {
          emit(PasswordUpdateSt(stateView: FailedStateView(errMsg: exeption)));
        }

        final Map<String, dynamic> unAuth = response["unauthenticated"] ?? {};
        if (unAuth.isNotEmpty) {
          emit(const PasswordUpdateSt(stateView: UnauthenticatedStateView()));
        }
      }

      await Future.delayed(const Duration(seconds: 1));
      emit(const PasswordUpdateSt(stateView: InitialStateView()));
    });

    on<LogoutEv>((event, emit) async {
      emit(const LogoutSt(stateView: LoadingStateView()));

      bool isOfline = await connectionService.isOfline();
      if (isOfline) {
        emit(const LogoutSt(stateView: OflineStateView()));
        await Future.delayed(const Duration(seconds: 1));
        emit(const LogoutSt(stateView: InitialStateView()));
        return;
      }

      Map<String, dynamic> response = await authApi.logoutApi(tokenService);

      if (response['success'] == true) {
        await tokenService.deleteLocalToken();
        await mePrefrences.deleteMe();
        emit(LogoutSt(stateView: SuccessStateView(data: response)));
      }

      if (response['success'] == false) {
        final Map<String, dynamic> errorMap = response["error"] ?? {};
        if (errorMap.isNotEmpty) {
          emit(LogoutSt(stateView: FailedStateView(errMsg: errorMap)));
        }

        final Map<String, dynamic> exeption = response["exeption"] ?? {};
        if (exeption.isNotEmpty) {
          emit(LogoutSt(stateView: FailedStateView(errMsg: exeption)));
          await tokenService.deleteLocalToken();
          await mePrefrences.deleteMe();

          emit(const LogoutSt(stateView: SuccessStateView()));
        }

        final Map<String, dynamic> unAuth = response["unauthenticated"] ?? {};
        if (unAuth.isNotEmpty) {
          emit(const LogoutSt(stateView: UnauthenticatedStateView()));
        }
      }

      await Future.delayed(const Duration(seconds: 1));
      emit(const LogoutSt(stateView: InitialStateView()));
    });

    on<MeEv>((event, emit) async {
      emit(const MeSt(stateView: LoadingStateView()));
      bool isOfline = await connectionService.isOfline();
      if (isOfline) {
        emit(const MeSt(stateView: OflineStateView()));
        await Future.delayed(const Duration(seconds: 1));
        emit(const MeSt(stateView: InitialStateView()));
        return;
      }

      Map<String, dynamic> response =
          await authApi.meApi(tokenService: tokenService);

      if (response['success'] == true) {
        final Map<String, dynamic> user = response['data']['user'];

        await mePrefrences.setMe(
            id: user['id'] ?? 0,
            namaLengkap: user['nama_lengkap'] ?? '',
            namaPanggilan: user['nama_panggilan'] ?? '',
            email: user['email'] ?? '',
            role: user['role'] ?? '',
            urlProfil: user['url_profil'] ?? '');

        emit(MeSt(stateView: SuccessStateView(data: response)));
      }

      if (response['success'] == false) {
        final Map<String, dynamic> errorMap = response["error"] ?? {};
        if (errorMap.isNotEmpty) {
          emit(MeSt(stateView: FailedStateView(errMsg: errorMap)));
        }

        final Map<String, dynamic> exeption = response["exeption"] ?? {};
        if (exeption.isNotEmpty) {
          emit(MeSt(stateView: FailedStateView(errMsg: exeption)));
        }

        final Map<String, dynamic> unAuth = response["unauthenticated"] ?? {};
        if (unAuth.isNotEmpty) {
          emit(const MeSt(stateView: UnauthenticatedStateView()));
        }
      }

      await Future.delayed(const Duration(seconds: 1));
      emit(const MeSt(stateView: InitialStateView()));
    });

    on<UpdateFotoProfilEv>((event, emit) async {
      emit(const UpdateFotoProfilSt(stateView: LoadingStateView()));

      bool isOfline = await connectionService.isOfline();
      if (isOfline) {
        emit(const UpdateFotoProfilSt(stateView: OflineStateView()));
        await Future.delayed(const Duration(seconds: 1));
        emit(const UpdateFotoProfilSt(stateView: InitialStateView()));
        return;
      }

      Map<String, dynamic> response = await authApi.updateFoto(
          gambarProfil: event.gambarUser, tokenService: tokenService);

      if (response['success'] == true) {
        final Map<String, dynamic> user = response['data']['user'];

        await mePrefrences.setMe(
            id: user['id'] ?? 0,
            namaLengkap: user['nama_lengkap'] ?? '',
            namaPanggilan: user['nama_panggilan'] ?? '',
            email: user['email'] ?? '',
            role: user['role'] ?? '',
            urlProfil: user['url_profil'] ?? '');

        emit(UpdateFotoProfilSt(stateView: SuccessStateView(data: response)));
      }

      if (response['success'] == false) {
        final Map<String, dynamic> errorMap = response["error"] ?? {};
        if (errorMap.isNotEmpty) {
          emit(
              UpdateFotoProfilSt(stateView: FailedStateView(errMsg: errorMap)));
        }

        final Map<String, dynamic> exeption = response["exeption"] ?? {};
        if (exeption.isNotEmpty) {
          emit(
              UpdateFotoProfilSt(stateView: FailedStateView(errMsg: exeption)));
        }

        final Map<String, dynamic> unAuth = response["unauthenticated"] ?? {};
        if (unAuth.isNotEmpty) {
          emit(const UpdateFotoProfilSt(stateView: UnauthenticatedStateView()));
        }
      }

      await Future.delayed(const Duration(seconds: 1));
      emit(const UpdateFotoProfilSt(stateView: InitialStateView()));
    });
  }
}
