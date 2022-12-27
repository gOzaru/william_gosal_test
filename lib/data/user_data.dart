// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:william_gosal_test/main_menu.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  static SharedPreferences? prefs;
  static String name = "";
  static String age = '';
  static bool done = false;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _age = TextEditingController();

  @override
  void initState() {
    super.initState();
    initShared();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Data')),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 70, height: 100, child: Text('Nama:', style: TextStyle(fontSize: 20.0))),
                SizedBox(
                  width: 280,
                  height: 50,
                  child: TextFormField(
                    controller: _name,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    enabled: (done == false) ? true : false,
                    decoration: InputDecoration(
                      label: Text((done == false) ? "" : name),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 70, height: 100, child: Text('Umur:', style: TextStyle(fontSize: 20.0))),
                SizedBox(
                  width: 280,
                  height: 50,
                  child: TextFormField(
                    controller: _age,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    enabled: (done == false) ? true : false,
                    decoration: InputDecoration(
                      label: Text((done == false) ? "" : age),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.save_sharp),
                iconSize: 36.0,
                onPressed: () async {
                  log("Save button is pressed");
                  if (_name.text.isNotEmpty) {
                    if (_age.text.isNotEmpty) {
                      await save();
                      showDialog(
                          //like that
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Message'),
                              content: Text('Data telah diinput\nNama Anda adalah $name, umur adalah $age'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.to(() => const MainMenu());
                                  },
                                  child: const Text('OK'),
                                )
                              ],
                            );
                          });
                    } else {
                      AlertDialog(
                        title: const Text('Warning'),
                        content: const Text('Umur Anda harus diisi!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.off(() => const UserData());
                            },
                            child: const Text('OK'),
                          )
                        ],
                      );
                    }
                  } else {
                    AlertDialog(
                      title: const Text('Warning'),
                      content: const Text('Nama Anda harus diisi!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.off(() => const UserData());
                          },
                          child: const Text('OK'),
                        )
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<int> save() async {
    prefs = await SharedPreferences.getInstance();
    log("Trying setState");
    setState(() {
      prefs!.setString("username", _name.text.toString());
      prefs!.setString("age", _age.text);
      prefs!.setBool("inputted", true);
    });
    name = prefs!.getString("username").toString();
    log(name);
    age = prefs!.getString("age").toString();
    log(age);
    return 0;
  }

  Future<void> initShared() async {
    prefs = await SharedPreferences.getInstance();
    done = prefs!.getBool("inputted")!;
    if (done == false) {
      setState(() {
        name = "";
        age = "";
      });
    } else {
      name = prefs!.getString("username").toString();
      age = prefs!.getString("age").toString();
    }
  }
}
