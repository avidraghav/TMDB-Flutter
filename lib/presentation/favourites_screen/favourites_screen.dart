import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/auth_state_cubit.dart';
import 'package:tmdb_flutter/data/shared_prefs_helper.dart';
import 'package:tmdb_flutter/domain/database_helper.dart';
import 'package:tmdb_flutter/main.dart';
import 'package:tmdb_flutter/presentation/favourites_screen/favourites_screen_vm.dart';
import 'package:tmdb_flutter/theme_cubit.dart';

import '../../domain/model/movie.dart';
import '../settings_screen/settings_screen.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  late FavouritesScreenVM viewModel;
  List<Movie> favourites = [];
  late bool isUserLoggedIn;
  late bool isDarkTheme;

  @override
  void initState() {

    getIt<DatabaseHelper>(instanceName: 'prod').db.then((db) {
      viewModel = FavouritesScreenVM(db);
    }).then((value) => {
          viewModel.getFavourites().then((favs) {
            setState(() {
              favourites = favs;
            });
          })
        });

    SharedPreferencesHelper.instance.getBool("isUserLoggedIn").then((value) {
      isUserLoggedIn = value;
    });
    SharedPreferencesHelper.instance.getBool("isDarkTheme").then((value) {
      isDarkTheme = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Favourite Movies")),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
            ),
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(providers: [
                      BlocProvider(
                        create: (BuildContext context) =>
                            AuthStateCubit(isUserLoggedIn),
                      ),
                      BlocProvider(
                        create: (BuildContext context) =>
                            ThemeCubit(isDarkTheme),
                      ),
                    ], child: const SettingsScreen()),
                  ));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
            itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${favourites[index].title}"),
                ),
            separatorBuilder: (_, index) => const Divider(),
            itemCount: favourites.length),
      ),
    );
  }
}
