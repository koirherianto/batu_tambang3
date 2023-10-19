import 'package:batu_tambang/auth_and_setting/bloc/auth_bloc.dart';
import 'package:batu_tambang/static_data/state_view.dart';
import 'package:flutter/material.dart';
import 'package:batu_tambang/static_data/decoration.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordPage extends StatelessWidget {
  PasswordPage({super.key});

  final TextEditingController _passwordLamaC = TextEditingController();
  final TextEditingController _passwordBaruC = TextEditingController();
  final TextEditingController _passwordConfirmC = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _errMsg = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.adaptive.arrow_back, color: Colors.black54),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: [
            const SizedBox(height: 60.0),
            const Text(
              'Batu Tambang',
              style: TextStyle(fontFamily: 'Trueno', fontSize: 30.0),
            ),
            const Text(
              'Ganti Password',
              style: TextStyle(fontFamily: 'Trueno', fontSize: 60.0),
            ),
            const SizedBox(height: 20),
            _formBloc()
          ],
        ),
      ),
    );
  }

  BlocBuilder<AuthBloc, AuthState> _formBloc() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is ProfileUpdateSt) {
          StateView stateView = state.stateView;

          if (stateView is LoadingStateView) {
            return _form(context, isLoading: true);
          }

          if (stateView is FailedStateView) {
            _setErrorMsg(stateView.errorMassage, context);
            if (_formKey.currentState != null) {
              _formKey.currentState!.validate();
            }
          }

          if (stateView is SuccessStateView) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('${stateView.data['message'] ?? 'Success'}'),
                    duration: const Duration(seconds: 1)),
              );
            });
            Navigator.pop(context);
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
            keyboardType: TextInputType.visiblePassword,
            validator: (_) => _errMsg['password_lama'],
            controller: _passwordLamaC,
            decoration: Decorations.inputDecoration(title: 'PASS LAMA'),
          ),
          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            validator: (_) => _errMsg['password_baru'],
            controller: _passwordBaruC,
            decoration: Decorations.inputDecoration(title: 'PASS BARU'),
          ),
          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            validator: (_) => _errMsg['password_confirm'],
            controller: _passwordConfirmC,
            decoration: Decorations.inputDecoration(title: 'KONFIRMASI PASS'),
          ),
          const SizedBox(height: 50.0),
          isLoading
              ? Decorations.submitButton(title: 'Loading')
              : GestureDetector(
                  onTap: () {
                    _errMsg.clear();
                    if (_formKey.currentState != null) {
                      if (_formKey.currentState!.validate()) {
                        // context.read<AuthBloc>().add(ProfileUpdateEv(
                        //       namaLengkap: _namaLengkapC.text,
                        //       namaPanggilan: _namaPanggilanC.text,
                        //       email: _emailC.text,
                        //     ));
                      }
                    }
                  },
                  child: Decorations.submitButton(title: 'Ubah Password'),
                ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _setErrorMsg(Map<String, dynamic> errorMassage, BuildContext context) {
    _errMsg.clear();

    for (var errMsg in errorMassage.entries) {
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
