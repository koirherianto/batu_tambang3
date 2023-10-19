import 'dart:io';

import 'package:batu_tambang/auth_and_setting/services/auth_api.dart';
import 'package:batu_tambang/auth_and_setting/services/me_prefrences.dart';
import 'package:batu_tambang/auth_and_setting/services/token_service.dart';
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
  AuthBloc({
    required this.authApi,
    required this.mePrefrences,
    required this.tokenService,
  }) : super(const AuthState()) {
    on<RegisterSubmitEv>((event, emit) async {
      emit(const RegisterSubmitSt(stateView: LoadingStateView()));

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
          emit(
            RegisterSubmitSt(
                stateView: FailedStateView(errorMassage: errorMap)),
          );
        }

        final Map<String, dynamic> exeption = response["exeption"] ?? {};
        if (exeption.isNotEmpty) {
          emit(
            RegisterSubmitSt(
                stateView: FailedStateView(errorMassage: exeption)),
          );
        }

        final Map<String, dynamic> unAuth = response["unauthenticated"] ?? {};
        if (unAuth.isNotEmpty) {
          emit(
            const RegisterSubmitSt(stateView: UnauthenticatedStateView()),
          );
        }
      }

      await Future.delayed(const Duration(seconds: 1));
      emit(const RegisterSubmitSt(stateView: InitialStateView()));
    });

    on<LoginSubmitEv>((event, emit) async {
      emit(const LoginSubmitSt(stateView: LoadingStateView()));

      Map<String, dynamic> response = await authApi.loginApi(
        email: event.email,
        password: event.password,
      );

      print(['response', response]);

      if (response['success'] == true) {
        Map<String, dynamic> dataUser = response['data']['user'];
        await mePrefrences.setMe(
          id: dataUser['id'] ?? 0,
          namaLengkap: dataUser['nama_lengkap'] ?? '',
          namaPanggilan: dataUser['nama_panggilan'] ?? '',
          email: dataUser['email'] ?? '',
          role: dataUser['role'] ?? '',
          urlProfil: response['url_profil'] ?? '',
        );
        await tokenService.setLocalToken(response['data']['token']);
        emit(const LoginSubmitSt(stateView: SuccessStateView()));
      }

      if (response['success'] == false) {
        final Map<String, dynamic> errorMap = response["error"] ?? {};
        if (errorMap.isNotEmpty) {
          emit(
            LoginSubmitSt(stateView: FailedStateView(errorMassage: errorMap)),
          );
        }

        final Map<String, dynamic> exeption = response["exeption"] ?? {};
        if (exeption.isNotEmpty) {
          emit(
            LoginSubmitSt(stateView: FailedStateView(errorMassage: exeption)),
          );
        }

        final Map<String, dynamic> unAuth = response["unauthenticated"] ?? {};
        if (unAuth.isNotEmpty) {
          emit(
            const LoginSubmitSt(stateView: UnauthenticatedStateView()),
          );
        }
      }

      await Future.delayed(const Duration(seconds: 1));
      emit(const LoginSubmitSt(stateView: InitialStateView()));
    });

    on<LogoutEv>((event, emit) async {
      emit(const LogoutSt(stateView: LoadingStateView()));

      Map<String, dynamic> response = await authApi.logoutApi(tokenService);

      if (response['success'] == true) {
        await tokenService.deleteLocalToken();
        await mePrefrences.deleteMe();
        emit(LogoutSt(stateView: SuccessStateView(data: response)));
      }

      if (response['success'] == false) {
        final Map<String, dynamic> errorMap = response["error"] ?? {};
        if (errorMap.isNotEmpty) {
          emit(
            LogoutSt(stateView: FailedStateView(errorMassage: errorMap)),
          );
        }

        final Map<String, dynamic> exeption = response["exeption"] ?? {};
        if (exeption.isNotEmpty) {
          emit(
            LogoutSt(stateView: FailedStateView(errorMassage: exeption)),
          );
        }

        final Map<String, dynamic> unAuth = response["unauthenticated"] ?? {};
        if (unAuth.isNotEmpty) {
          emit(
            const LogoutSt(stateView: UnauthenticatedStateView()),
          );
        }
      }

      await Future.delayed(const Duration(seconds: 1));
      emit(const LogoutSt(stateView: InitialStateView()));
    });

    on<ProfileUpdateEv>((event, emit) async {
      emit(const ProfileUpdateSt(stateView: LoadingStateView()));

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
          urlProfil: response['url_profil'] ?? '',
        );
        emit(ProfileUpdateSt(stateView: SuccessStateView(data: response)));
      }

      if (response['success'] == false) {
        final Map<String, dynamic> errorMap = response["error"] ?? {};
        if (errorMap.isNotEmpty) {
          emit(
            ProfileUpdateSt(stateView: FailedStateView(errorMassage: errorMap)),
          );
        }

        final Map<String, dynamic> exeption = response["exeption"] ?? {};
        if (exeption.isNotEmpty) {
          emit(
            ProfileUpdateSt(stateView: FailedStateView(errorMassage: exeption)),
          );
        }

        final Map<String, dynamic> unAuth = response["unauthenticated"] ?? {};
        if (unAuth.isNotEmpty) {
          emit(
            const ProfileUpdateSt(stateView: UnauthenticatedStateView()),
          );
        }
      }

      await Future.delayed(const Duration(seconds: 1));
      emit(const ProfileUpdateSt(stateView: InitialStateView()));
    });
  }
}
