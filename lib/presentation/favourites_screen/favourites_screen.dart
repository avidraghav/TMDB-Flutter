import 'package:flutter/material.dart';
import 'package:tmdb_flutter/presentation/favourites_screen/favourites_screen_vm.dart';

import '../../data/database_helper.dart';
import '../../domain/model/movie.dart';

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
