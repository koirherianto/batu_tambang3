import 'package:batu_tambang/auth_and_setting/bloc/auth_bloc.dart';
import 'package:batu_tambang/auth_and_setting/pages/profile_page.dart';
import 'package:batu_tambang/main.dart';
import 'package:batu_tambang/static_data/state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: SettingsList(
              backgroundColor: Colors.white60,
              sections: [
                SettingsSection(
                  title: 'Account',
                  tiles: [
                    SettingsTile(
                      title: 'Profil',
                      subtitle: 'Nama & Email',
                      leading: const Icon(Icons.person),
                      onPressed: (BuildContext context) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ProfilePage()),
                        );
                      },
                    ),
                    SettingsTile(
                      title: 'Password',
                      subtitle: 'Rubah Password',
                      leading: const Icon(Icons.password),
                      onPressed: (BuildContext context) {},
                    ),
                    // logoutButton() as SettingsTile,
                  ],
                ),
              ],
            ),
          ),
          logoutButton()
        ],
      ),
    );
  }

  BlocBuilder<AuthBloc, AuthState> logoutButton() {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is LogoutSt) {
        StateView stateView = state.stateView;
        print(['logout state', state]);
        if (stateView is LoadingStateView) {
          return button(isLoading: true);
        }

        if (stateView is FailedStateView) {
          // pesan logout gagal
          SchedulerBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(' Logout gagal'),
                duration: Duration(seconds: 1),
              ),
            );
          });
        }

        if (stateView is SuccessStateView) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${stateView.data['message']}}'),
                duration: const Duration(seconds: 1),
              ),
            );

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const IsLogin()));
          });
        }

        if (stateView is UnauthenticatedStateView) {
          // do something
        }
      }
      return button();
    });
  }

  Widget button({bool isLoading = false}) {
    return isLoading
        ? SettingsTile(
            title: 'Loading...',
            subtitle: 'Keluar dari akun',
            leading: const Icon(Icons.logout_outlined),
          )
        : SettingsTile(
            title: 'Logout',
            subtitle: 'Keluar dari akun',
            leading: const Icon(Icons.logout),
            onPressed: (BuildContext context) {
              context.read<AuthBloc>().add(LogoutEv());
            },
          );
  }
}
