import 'package:batu_tambang/auth_and_setting/bloc/auth_bloc.dart';
import 'package:batu_tambang/static_data/state_view.dart';
import 'package:flutter/material.dart';
import 'package:batu_tambang/static_data/decoration.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passwordC = TextEditingController();
  final TextEditingController _namaLengkapC = TextEditingController();
  final TextEditingController _namaPanggilanC = TextEditingController();

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
              'SSSSSSS',
              style: TextStyle(fontFamily: 'Trueno', fontSize: 30.0),
            ),
            const Text(
              'Register',
              style: TextStyle(fontFamily: 'Trueno', fontSize: 60.0),
            ),
            const SizedBox(height: 20),
            _formBloc(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Sudah punya akun ?'),
                const SizedBox(width: 5.0),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Login',
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
        if (state is RegisterSubmitSt) {
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Berhasil Terdaftar, Silahkan Masuk'),
                    duration: Duration(seconds: 1)),
              );
              Navigator.pop(context);
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
            controller: _namaLengkapC,
            validator: (_) => _errMsg['nama_lengkap'],
            keyboardType: TextInputType.name,
            decoration: Decorations.inputDecoration(title: 'NAMA LENGKAP'),
          ),
          TextFormField(
            controller: _namaPanggilanC,
            validator: (_) => _errMsg['nama_panggilan'],
            keyboardType: TextInputType.name,
            decoration: Decorations.inputDecoration(title: 'NAMA PANGGILAN'),
          ),
          TextFormField(
            controller: _emailC,
            validator: (_) => _errMsg['email'],
            keyboardType: TextInputType.emailAddress,
            decoration: Decorations.inputDecoration(title: 'EMAIL'),
          ),
          TextFormField(
            obscureText: true,
            controller: _passwordC,
            keyboardType: TextInputType.visiblePassword,
            validator: (_) => _errMsg['password'],
            decoration: Decorations.inputDecoration(title: 'PASSWORD'),
          ),
          const SizedBox(height: 50.0),
          isLoading
              ? Decorations.submitButton(title: 'Loading')
              : GestureDetector(
                  onTap: () {
                    _errMsg.clear();
                    if (_formKey.currentState != null) {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(RegisterSubmitEv(
                              namaLengkap: _namaLengkapC.text,
                              namaPanggilan: _namaPanggilanC.text,
                              password: _passwordC.text,
                              email: _emailC.text,
                            ));
                      }
                    }
                  },
                  child: Decorations.submitButton(title: 'Daftar'),
                ),
          const SizedBox(height: 20),
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
