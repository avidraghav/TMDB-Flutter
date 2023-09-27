import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/presentation/settings_screen/SettingsScreenCubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
        title: const Text("Settings"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<SettingsScreenCubit, SettingsScreenState>(
              builder: (context, state) {
            return Column(
              children: [
                ColumnItem(
                    leadIcon: Icons.shield_moon,
                    text1: "Theme",
                    text2: "Dark Mode",
                    trailing: Switch(
                      onChanged: (bool value) {
                        context.read<SettingsScreenCubit>().toggleTheme();
                      },
                      value: state.isDarkMode,
                    )),
                const ColumnItem(
                    leadIcon: Icons.supervised_user_circle_outlined,
                    text1: "Account",
                    text2: "Sign Out",
                    trailing: Icon(Icons.arrow_forward))
              ],
            );
          })),
    );
  }
}

class ColumnItem extends StatelessWidget {
  final IconData leadIcon;
  final String text1;
  final String text2;
  final Widget trailing;

  const ColumnItem(
      {super.key,
      required this.leadIcon,
      required this.text1,
      required this.text2,
      required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(leadIcon),
        Container(
          margin: const EdgeInsets.only(
              left: 8.0, top: 8.0, bottom: 8.0, right: 12.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(text1), Text(text2)]),
        ),
        const Spacer(),
        trailing
      ],
    );
  }
}