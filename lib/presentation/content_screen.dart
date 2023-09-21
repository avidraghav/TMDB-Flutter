import 'package:flutter/material.dart';

import 'favourites_screen.dart';
import 'movies_screen.dart';

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
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const MoviesScreen();
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
