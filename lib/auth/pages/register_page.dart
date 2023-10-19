import 'package:flutter/material.dart';
import 'package:batu_tambang/static_data/decoration.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: [
            const SizedBox(height: 75.0),
            const Text(
              'Batu Tambang',
              style: TextStyle(fontFamily: 'Trueno', fontSize: 30.0),
            ),
            const Text(
              'Register',
              style: TextStyle(fontFamily: 'Trueno', fontSize: 60.0),
            ),
            const SizedBox(height: 20),
            _form(context),
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

  Form _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            // validator: (value) => errMsg['email'],
            keyboardType: TextInputType.name,
            decoration: Decorations.inputDecoration(title: 'NAMA LENGKAP'),
          ),
          TextFormField(
            controller: _emailController,
            // validator: (value) => errMsg['email'],
            keyboardType: TextInputType.name,
            decoration: Decorations.inputDecoration(title: 'NAMA PANGGILAN'),
          ),
          TextFormField(
            controller: _emailController,
            // validator: (value) => errMsg['email'],
            keyboardType: TextInputType.emailAddress,
            decoration: Decorations.inputDecoration(title: 'EMAIL'),
          ),
          TextFormField(
            obscureText: true,
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            // validator: (value) => errMsg['password'],
            decoration: Decorations.inputDecoration(title: 'PASSWORD'),
          ),
          const SizedBox(height: 10.0),
          const SizedBox(height: 50.0),
          GestureDetector(
            onTap: () {
              if (_formKey.currentState != null) {
                if (_formKey.currentState!.validate()) {
                  // context.read<AuthBloc>().add(
                  //     LoginEv(email: _email.text, password: _password.text));
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
}
