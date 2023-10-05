import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_flutter/data/shared_prefs_helper.dart';
import 'package:tmdb_flutter/presentation/auth_screen/auth_screen_cubit.dart';
import 'package:tmdb_flutter/presentation/auth_screen/auth_screen_vm.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late AuthScreenVM _viewModel;
  late TextEditingController _controllerEmail;
  late TextEditingController _controllerPassword;

  @override
  void initState() {
    super.initState();
    _viewModel = AuthScreenVM();
    _controllerEmail = TextEditingController();
    _controllerPassword = TextEditingController();
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child: BlocBuilder<AuthScreenCubit, AuthScreenState>(
          builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Authentication"),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'enter your email here',
                  ),
                  controller: _controllerEmail,
                  onSubmitted: (String value) async {},
                  onChanged: (String value) {
                    context.read<AuthScreenCubit>().setEmail(value.trim());
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'enter your password here',
                  ),
                  obscureText: true,
                  controller: _controllerPassword,
                  onSubmitted: (String value) async {},
                  onChanged: (String value) {
                    context.read<AuthScreenCubit>().setPassword(value.trim());
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      if (state.email != null &&
                          state.email!.isNotEmpty &&
                          state.password != null &&
                          state.password!.isNotEmpty) {
                        context.read<AuthScreenCubit>().setIsLoading(true);
                        _viewModel
                            .authenticateUser(
                                emailAddress: state.email!,
                                password: state.password!)
                            .then((user) {
                          if (user != null) {
                            print("success");
                            context.read<AuthScreenCubit>().setIsLoading(false);
                            SharedPreferencesHelper.instance
                                .setBool("isUserLoggedIn", true);
                            context.go("/home_page/content_screen");
                          } else {
                            print("fail");
                            context.read<AuthScreenCubit>().setIsLoading(false);
                            SharedPreferencesHelper.instance
                                .setBool("isUserLoggedIn", false);
                            //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("error")));
                          }
                        });
                      }
                    },
                    child: const Text("Authenticate")),
                if (state.isLoading) const CircularProgressIndicator()
              ],
            ),
          ),
        );
      }),
    ));
  }
}
