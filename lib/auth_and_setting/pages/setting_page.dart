import 'dart:io';

import 'package:batu_tambang/auth_and_setting/bloc/auth_bloc.dart';
import 'package:batu_tambang/auth_and_setting/pages/password_page.dart';
import 'package:batu_tambang/auth_and_setting/pages/profile_page.dart';
import 'package:batu_tambang/auth_and_setting/services/me_prefrences.dart';
import 'package:batu_tambang/main.dart';
import 'package:batu_tambang/model/user_model.dart';
import 'package:batu_tambang/static_data/decoration.dart';
import 'package:batu_tambang/static_data/state_view.dart';
import 'package:batu_tambang/static_data/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title:
            Text('Pengaturan', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Column(
        children: [
          UserProfilPicture(),
          const SizedBox(height: 10),
          getNameUser(context),
          _profilLogic(context),
          SettingsTile(
            title: 'Password',
            subtitle: 'Rubah Password',
            leading: const Icon(Icons.password),
            onPressed: (BuildContext context) {
              pushNewScreen(
                context,
                screen: PasswordPage(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          ),
          _logoutLogic()
        ],
      ),
    );
  }

  FutureBuilder<UserModel> _profilLogic(BuildContext context) {
    return FutureBuilder(
      future: context.read<MePrefrences>().getModelMe(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          UserModel userModel = snapshot.data as UserModel;
          return profileButton(userModel: userModel);
        }
        return profileButton(isLoading: true);
      },
    );
  }

  BlocBuilder<AuthBloc, AuthState> _logoutLogic() {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is LogoutSt) {
        StateView stateView = state.stateView;
        if (stateView is LoadingStateView) {
          return logoutButton(isLoading: true);
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
          SchedulerBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(stateView.errMsg['catch'].toString()),
                duration: const Duration(seconds: 1),
              ),
            );
          });
        }

        if (stateView is SuccessStateView) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${stateView.data['message'] ?? 'Success'}'),
                duration: const Duration(seconds: 1),
              ),
            );

            Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(builder: (_) => const IsLogin()));
          });
        }

        if (stateView is UnauthenticatedStateView) {
          // do something
        }
      }
      return logoutButton();
    });
  }

  Widget profileButton({bool isLoading = false, UserModel? userModel}) {
    return isLoading
        ? SettingsTile(
            title: 'Profil...',
            subtitle: 'Nama & Email...',
            leading: const Icon(Icons.person_outline),
          )
        : SettingsTile(
            title: 'Profil',
            subtitle: 'Nama & Email',
            leading: const Icon(Icons.person),
            onPressed: (BuildContext context) {
              pushNewScreen(
                context,
                screen: ProfilePage(userModel: userModel!),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          );
  }

  Widget logoutButton({bool isLoading = false}) {
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

  Widget getNameUser(BuildContext context) {
    return FutureBuilder<UserModel>(
        future: context.read<MePrefrences>().getModelMe(),
        builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Text(
                    (snapshot.data?.namaLengkap ?? '').toCapitalized2(),
                    style: const TextStyle(
                      color: Decorations.blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    (snapshot.data?.role ?? '').toCapitalized2(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Decorations.blackColor.withOpacity(.3),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Terjadi kesalahan: ${snapshot.error}');
            }
          }
          return const SizedBox();
        });
  }
}

// ignore: must_be_immutable
class UserProfilPicture extends StatelessWidget {
  UserProfilPicture({super.key});

  File? gambarProfil;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          pickImage(context).then((bool haveFile) {
            haveFile
                ? context
                    .read<AuthBloc>()
                    .add(UpdateFotoProfilEv(gambarUser: gambarProfil))
                : null;
          });
        },
        child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.teal.shade100, width: 5.0),
            ),
            child: _avatarLogic()));
  }

  BlocBuilder<AuthBloc, AuthState> _avatarLogic() {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is UpdateFotoProfilSt) {
        StateView stateView = state.stateView;
        if (stateView is LoadingStateView) {
          return const CircularProgressIndicator();
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
          SchedulerBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(stateView.errMsg['catch'].toString()),
                duration: const Duration(seconds: 1),
              ),
            );
          });
        }

        if (stateView is SuccessStateView) {
          return profileImage(context);
        }

        if (stateView is UnauthenticatedStateView) {
          // do something
        }
      }
      return profileImage(context);
    });
  }

  Widget profileImage(BuildContext context) {
    String? photoUrl = context.read<MePrefrences>().userModel?.photoUrl;
    return gambarProfil != null
        ? Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: Image.file(gambarProfil!).image,
                fit: BoxFit.fill,
              ),
            ),
          )
        : photoUrl != '' && photoUrl != null
            ? Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: Image.network(photoUrl).image,
                    fit: BoxFit.fill,
                  ),
                ),
              )
            : const CircleAvatar(
                radius: 60,
                backgroundImage: ExactAssetImage('assets/images/profile.png'),
              );
  }

  Future<bool> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagePicked =
        await picker.pickImage(source: ImageSource.gallery);

    if (imagePicked != null) {
      gambarProfil = File(imagePicked.path);
      return true;
    } else {
      return false;
    }
  }
}
