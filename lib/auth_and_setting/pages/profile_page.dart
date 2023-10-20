import 'package:batu_tambang/auth_and_setting/bloc/auth_bloc.dart';
import 'package:batu_tambang/model/user_model.dart';
import 'package:batu_tambang/static_data/state_view.dart';
import 'package:flutter/material.dart';
import 'package:batu_tambang/static_data/decoration.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  final UserModel userModel;
  ProfilePage({super.key, required this.userModel}) {
    _emailC.text = userModel.email;
    _namaLengkapC.text = userModel.namaLengkap;
    _namaPanggilanC.text = userModel.namaPanggilan;
  }

  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _namaLengkapC = TextEditingController();
  final TextEditingController _namaPanggilanC = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _errMsg = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
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
              'Profile',
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
            _setErrorMsg(stateView.errMsg, context);
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
            keyboardType: TextInputType.name,
            validator: (_) => _errMsg['nama_lengkap'],
            controller: _namaLengkapC,
            decoration: Decorations.inputDecoration(title: 'NAMA LENGKAP'),
          ),
          TextFormField(
            keyboardType: TextInputType.name,
            validator: (_) => _errMsg['nama_panggilan'],
            controller: _namaPanggilanC,
            decoration: Decorations.inputDecoration(title: 'NAMA PANGGILAN'),
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            validator: (_) => _errMsg['email'],
            controller: _emailC,
            decoration: Decorations.inputDecoration(title: 'EMAIL'),
          ),
          const SizedBox(height: 50.0),
          isLoading
              ? Decorations.submitButton(title: 'Loading', color: Colors.grey)
              : GestureDetector(
                  onTap: () {
                    _errMsg.clear();
                    if (_formKey.currentState != null) {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(ProfileUpdateEv(
                              namaLengkap: _namaLengkapC.text,
                              namaPanggilan: _namaPanggilanC.text,
                              email: _emailC.text,
                            ));
                      }
                    }
                  },
                  child: Decorations.submitButton(title: 'Ubah Profil'),
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
