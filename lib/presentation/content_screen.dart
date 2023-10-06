import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/presentation/favourites_screen/favourites_screen.dart';
import 'package:tmdb_flutter/presentation/movies_screen/movies_screen_cubit.dart';
import 'movies_screen/movies_screen.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  int selectedIndex = 0;

  void navigationItemClicked(int value) {
    setState(() {
      selectedIndex = value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page =  BlocProvider(
          create: (BuildContext context) => MoviesScreenCubit(),
          child: const MoviesScreen(),
        );
        break;
      case 1:
        page = const FavouritesScreen();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
            SafeArea(
              child: NavigationBar(
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.play_arrow),
                    label: 'Movies',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.star_border),
                    label: 'Favourites',
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  navigationItemClicked(value);
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
