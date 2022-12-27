// ignore_for_file: file_names

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
  static late SharedPreferences prefs;
  static late String name;
  static late String age;
  static late bool done;
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
              children: [
                const Text('Nama:', style: TextStyle(fontSize: 20.0)),
                TextFormField(
                  controller: _name,
                  initialValue: name,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Enter your full name',
                    labelText: 'Full Name',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Umur:', style: TextStyle(fontSize: 20.0)),
                TextFormField(
                  controller: _age,
                  initialValue: age,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Enter your age',
                    labelText: 'Age',
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () async {
                await save().then((value) {
                  if (value == 0) {
                    AlertDialog(
                      title: const Text('Message'),
                      content: const Text('Data telah diinput'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.off(() => const MainMenu());
                          },
                          child: const Text('OK'),
                        )
                      ],
                    );
                  } else {
                                        AlertDialog(
                      title: const Text('Warning'),
                      content: const Text('Data Anda harus diisi semua!'),
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
                });
              },
              icon: const Icon(Icons.save_as_sharp),
              iconSize: 28.0,
            ),
          ],
        ),
      ),
    );
  }

  Future<int> save() async {
    prefs = await SharedPreferences.getInstance();
    if (_name.text.isNotEmpty && _age.text.isNotEmpty) {
      prefs.setString("username", _name.text.toString());
      prefs.setString("age", _age.text);
      prefs.setBool("inputted", true);
      name = prefs.getString("username").toString();
      age = prefs.getString("age").toString();
      return 0;
    } else {
      _name.clear();
      _age.clear();
      name = "John Doe";
      return 1;
    }
  }

  Future<void> initShared() async {
    prefs = await SharedPreferences.getInstance();
    done = prefs.getBool("inputted")!;
    if (done == false) {
      name = "";
    } else {
      name = prefs.getString("username").toString();
      age = prefs.getString("age").toString();
    }
  }
}
