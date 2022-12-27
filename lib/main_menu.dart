import 'dart:developer';

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
  static SharedPreferences? prefs;
  static String? name;

  @override
  void initState() {
    super.initState();
    initShared();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc Test'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: displayMenu(),
    );
  }

  Widget displayMenu() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Hello, $name", style: const TextStyle(fontSize: 18.0)),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Get.to(() => const ArticlesPage());
                  },
                  icon: const Icon(Icons.article_sharp),
                  iconSize: 128.0,
                ),
                IconButton(
                  onPressed: () {
                    Get.to(() => const UserData());
                  },
                  icon: const Icon(Icons.save_sharp),
                  iconSize: 128.0,
                ),
              ],
            ),
          ),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('Copyright Wege @2022'),
          ),
        )
      ],
    );
  }

  Future<void> initShared() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs!.containsKey("username") == true) {
      setState(() {
        name = prefs!.getString("username").toString();
      });
      log("true, $name!");
    } else {
      setState(() {
        prefs!.setBool("inputted", false);
        name = "John Doe";
      });
      log(name!);
    }
  }
}
