import 'package:flutter/material.dart';
import 'package:lsp/models/user.dart';
import 'package:lsp/database_helper.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<bool> checkUser(String username) async {
    User? user = await DatabaseHelper.instance.queryUser(username);
    if (user != null) {
      return true; // Login berhasil
    } else {
      return false; // Gagal login
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    checkUser('pramudya').then((value) {
      if (!value) {
        User user = User(id: 0, username: 'pramudya', password: '12345678');
        DatabaseHelper.instance.insertUser(user);
      }
    });

    return MaterialApp(
      title: 'LSP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
    );
  }
}
