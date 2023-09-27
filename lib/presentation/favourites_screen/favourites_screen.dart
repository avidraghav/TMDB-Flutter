import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/presentation/favourites_screen/favourites_screen_vm.dart';

import '../../data/database_helper.dart';
import '../../domain/model/movie.dart';
import '../settings_screen/SettingsScreenCubit.dart';
import '../settings_screen/settings_screen.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  late FavouritesScreenVM viewModel;
  List<Movie> favourites = [];

  @override
  void initState() {
    DatabaseHelper().db.then((db) {
      viewModel = FavouritesScreenVM(db);
    }).then((value) => {
          viewModel.getFavourites().then((favs) {
            setState(() {
              favourites = favs;
            });
          })
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
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                        create: (_) =>
                            SettingsScreenCubit(const SettingsScreenState()),
                        child: const SettingsScreen()),
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
