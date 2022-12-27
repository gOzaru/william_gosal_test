import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:william_gosal_test/articles/articles.dart';
import 'package:william_gosal_test/data/user_Data.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  static late SharedPreferences prefs;
  static late String name;

  @override
  void initState() {
    super.initState();
    initShared();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bloc Test'), centerTitle: true),
      body: displayMenu(),
    );
  }

  Widget displayMenu() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text("Hello, $name"),
        ),
        Align(
          alignment: Alignment.center,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.off(() => const ArticlesPage());
                },
                icon: const Icon(Icons.article_sharp),
                iconSize: 36.0,
              ),
              IconButton(
                onPressed: () {
                  Get.off(() => const UserData());
                },
                icon: const Icon(Icons.save_sharp),
                iconSize: 36.0,
              ),
            ],
          ),
        ), 
        const Align(
          alignment: Alignment.bottomCenter,
          child: Text('Copyright Wege @2022'),
        )
      ],
    );
  }

  Future<void> initShared() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString("username").toString();
    if (name.isEmpty) {
      name = "John Doe";
      prefs.setBool("inputted", false);
    } else {
      name = prefs.getString("username").toString();
    }
  }
}
