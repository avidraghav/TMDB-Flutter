import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/presentation/auth_screen/auth_screen.dart';
import 'package:tmdb_flutter/presentation/auth_screen/auth_screen_cubit.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({
    super.key,
  });

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;

  void _nextPage() {
    if (currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() {
        currentPage++;
      });
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BlocProvider(
                  create: (_) => AuthScreenCubit(const AuthScreenState()),
                  child: const AuthScreen()))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (currentPage + 1) / 3,
              minHeight: 10.0,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                children: [
                  OnBoardingPage(
                    title: 'Page 1',
                    subTitle: 'subtitle',
                    isLastPage: false,
                    buttonClicked: _nextPage,
                  ),
                  OnBoardingPage(
                    title: 'Page 2',
                    subTitle: 'subtitle',
                    isLastPage: false,
                    buttonClicked: _nextPage,
                  ),
                  OnBoardingPage(
                    title: 'Page 3',
                    subTitle: 'subtitle',
                    isLastPage: true,
                    buttonClicked: _nextPage,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.isLastPage,
      required this.buttonClicked});

  final String title;
  final String subTitle;
  final bool isLastPage;
  final void Function() buttonClicked;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title),
        Text(subTitle),
        if (isLastPage)
          ElevatedButton.icon(
              onPressed: buttonClicked,
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Let's Go"))
        else
          FloatingActionButton(
              onPressed: buttonClicked, child: const Icon(Icons.arrow_forward))
      ],
    );
  }
}
