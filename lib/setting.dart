import 'package:flutter/material.dart';
import 'package:lsp/models/user.dart';
import 'package:lsp/database_helper.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late User user;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
  }

  Future<bool> checkUser(String username) async {
    User? user = await DatabaseHelper.instance.queryUser(username);
    if (user != null) {
      return true; // Login berhasil
    } else {
      return false; // Gagal login
    }
  }

  Future<User?> login(String username, String password) async {
    User? user = await DatabaseHelper.instance.queryUser(username);
    return user;
  }

  void _resetFields() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
  }

  void _savePassword(currentPassword, newPassword) {
    // Implementasi simpan password di sini
    // Anda dapat menggunakan nilai dari _currentPasswordController.text dan _newPasswordController.text
    // Misalnya, Anda bisa menyimpannya di database atau melakukan operasi lain sesuai kebutuhan
    if (currentPassword == user.password) {
      DatabaseHelper.instance.queryUpdatePassword(user.id, newPassword);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password lama salah!'),
        ),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password berhasil diubah!'),
      ),
    );
    _resetFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ganti Password',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Password Lama"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Isikan password lama anda!';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Password Baru"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Isikan password baru anda!';
                }
                return null;
              },
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Aksi ketika tombol simpan ditekan
                String currentPassword = _currentPasswordController.text;
                String newPassword = _newPasswordController.text;

                _savePassword(currentPassword, newPassword);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Simpan'),
            ),
            ElevatedButton(
              onPressed: () {
                // Aksi ketika tombol kembali ditekan
                Navigator.pop(context);
              },
              child: Text('Kembali'),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/foto.jpg', // Sesuaikan dengan path gambar Anda
                      width: 150, // Sesuaikan ukuran gambar sesuai keinginan
                      height: 150, // Sesuaikan ukuran gambar sesuai keinginan
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About this app',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('Aplikasi ini dibuat oleh :'),
                    Text('Nama : Pramudya Wibowo'),
                    Text('NIM : 1941720054'),
                    Text('Tanggal : 30 September 2023'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
