import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/data/database_helper.dart';
import 'package:tmdb_flutter/domain/model/movie.dart';
import 'package:tmdb_flutter/presentation/details_screen/DetailsScreenCubit.dart';
import 'package:tmdb_flutter/presentation/details_screen/details_screen_vm.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late DetailsScreenVM viewModel;

  @override
  void initState() {
    DatabaseHelper().db.then((db) {
      viewModel = DetailsScreenVM(db);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: BlocBuilder<DetailsScreenCubit, DetailsScreenState>(
            builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.movie.title.toString()),
              GestureDetector(
                onTap: () {},
                child: ElevatedButton.icon(
                  onPressed: () {
                    viewModel.toggleFavourite(widget.movie).then((_) =>
                        context.read<DetailsScreenCubit>().toggleFavourite());
                  },
                  icon: state.isFavourite
                      ? const Icon(Icons.star)
                      : const Icon(Icons.star_outline),
                  label: const Text("Favourite"),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
