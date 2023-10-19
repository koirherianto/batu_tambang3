import 'package:batu_tambang/auth/bloc/auth_bloc.dart';
import 'package:batu_tambang/auth/pages/login_page.dart';
import 'package:batu_tambang/auth/services/auth_api.dart';
import 'package:batu_tambang/auth/services/me_prefrences.dart';
import 'package:batu_tambang/auth/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const ClassStream());
}

class ClassStream extends StatelessWidget {
  const ClassStream({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthApi()),
        RepositoryProvider(create: (_) => MePrefrences()),
        RepositoryProvider(create: (_) => TokenService()),
      ],
      child: const Aaaa(),
    );
  }
}

class Aaaa extends StatelessWidget {
  const Aaaa({super.key});

  @override
  Widget build(BuildContext context) {
    return const BlocStream();
  }
}

class BlocStream extends StatelessWidget {
  const BlocStream({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authApi: context.read<AuthApi>(),
            mePrefrences: context.read<MePrefrences>(),
            tokenService: context.read<TokenService>(),
          ),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Batu Tambang',
      debugShowCheckedModeBanner: false,
      routes: {
        '/loginPage': (_) => LoginPage(),
      },
      home: SafeArea(child: LoginPage()),
    );
  }
}
