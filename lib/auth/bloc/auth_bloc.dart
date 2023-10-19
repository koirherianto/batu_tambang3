import 'dart:io';

import 'package:batu_tambang/auth/services/auth_api.dart';
import 'package:batu_tambang/auth/services/me_prefrences.dart';
import 'package:batu_tambang/auth/services/token_service.dart';
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
    on<LoginSubmitEv>((event, emit) async {
      emit(const LoginSubmitSt(stateView: LoadingStateView()));

      Map<String, dynamic> response = await authApi.loginApi(
        email: event.email,
        password: event.password,
      );

      if (response['success'] == true) {
        // await tokenService.setLocalToken(response['data']['token']);
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

        // print(['exeption bloc', exeption]);

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
  }
}
