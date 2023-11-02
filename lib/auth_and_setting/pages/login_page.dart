import 'package:batu_tambang/auth_and_setting/bloc/auth_bloc.dart';
import 'package:batu_tambang/auth_and_setting/pages/register_page.dart';
import 'package:batu_tambang/index_page.dart';
import 'package:batu_tambang/static_data/state_view.dart';
import 'package:flutter/material.dart';
import 'package:batu_tambang/static_data/decoration.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _errMsg = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: [
            const SizedBox(height: 75.0),
            const Text(
              'Batu',
              style: TextStyle(fontFamily: 'Trueno', fontSize: 60.0),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Tambang',
                  style: TextStyle(fontFamily: 'Trueno', fontSize: 60.0),
                ),
                Container(
                  height: 10.0,
                  width: 10.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Decorations.titikHijau,
                  ),
                ),
              ],
            ),
            _formBloc(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Baru di Batu Tambang ?'),
                const SizedBox(width: 5.0),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => RegisterPage()),
                    );
                  },
                  child: const Text(
                    'Daftar',
                    style: TextStyle(
                      color: Decorations.greenColor,
                      fontFamily: 'Trueno',
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  BlocBuilder<AuthBloc, AuthState> _formBloc() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is LoginSubmitSt) {
          StateView stateView = state.stateView;
          if (stateView is LoadingStateView) {
            return _form(context, isLoading: true);
          }

          if (stateView is OflineStateView) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Anda Sedang Offline'),
                    duration: Duration(seconds: 1)),
              );
            });
          }

          if (stateView is FailedStateView) {
            _setErrorMsg(stateView.errMsg, context);
            if (_formKey.currentState != null) {
              _formKey.currentState!.validate();
            }
          }

          if (stateView is SuccessStateView) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const IndexPage()));
            });
          }

          if (stateView is UnauthenticatedStateView) {
            // do something
          }
        }
        return _form(context);
      },
    );
  }

  Form _form(BuildContext context, {bool isLoading = false}) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            validator: (_) => _errMsg['email'],
            keyboardType: TextInputType.emailAddress,
            decoration: Decorations.inputDecoration(title: 'EMAIL'),
          ),
          TextFormField(
            obscureText: true,
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            validator: (value) => _errMsg['password'],
            decoration: Decorations.inputDecoration(title: 'PASSWORD'),
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (_) => const ResetPasswordPage(),
                  //   ),
                  // );
                },
                child: const Text(
                  'Lupa Password ?',
                  style: TextStyle(
                    color: Decorations.greenColor,
                    fontFamily: 'Trueno',
                    fontSize: 11.0,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50.0),
          isLoading
              ? Decorations.submitButton(title: 'Loading')
              : GestureDetector(
                  onTap: () {
                    _errMsg.clear();
                    if (_formKey.currentState != null) {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(LoginSubmitEv(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ));
                      }
                    }
                  },
                  child: Decorations.submitButton(title: 'Login'),
                )
        ],
      ),
    );
  }

  void _setErrorMsg(Map<String, dynamic> errMsg, BuildContext context) {
    _errMsg.clear();

    for (var errMsg in errMsg.entries) {
      String key = errMsg.key;
      var value = errMsg.value;

      if (value is List) {
        _errMsg[key] = value[0];
      } else {
        _errMsg[key] = value;
      }
    }

    if (_errMsg['catch'] != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(' ${_errMsg['catch']}'),
            duration: const Duration(seconds: 1),
          ),
        );
      });
    }
  }
}
