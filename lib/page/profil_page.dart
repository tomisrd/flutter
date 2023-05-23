import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProfilePage extends StatefulWidget {
  final int accountId; // Ajout de la variable accountId

  ProfilePage({required this.accountId}); // Ajout du constructeur

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'your_database.db');
    return openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute(
          'CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, login TEXT, password TEXT)');
    });
  }

  Future<Map<String, Object>?> _getUserData() async {
    final database = await _openDatabase();
    final results = await database.query('users', where: 'id = ?', whereArgs: [widget.accountId], limit: 1);
    return results.isNotEmpty ? results.first.cast<String, Object>() : null;
  }

  Future<void> _updateAccountData() async {
    final database = await _openDatabase();
    final userData = await _getUserData();
    if (userData != null) {
      final accountId = userData['id'] as int?;
      final newLogin = _loginController.text;
      final newPassword = _passwordController.text;
      final updatedData = {
        'login': newLogin,
        'password': newPassword,
      };
      await database.update(
        'users',
        updatedData,
        where: 'id = ?',
        whereArgs: [accountId],
      );
      print('Données du compte mises à jour avec succès !');
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData().then((userData) {
      if (userData != null) {
        if (userData.containsKey('login') && userData.containsKey('password')) {
          _loginController.text = userData['login'].toString();
          _passwordController.text = userData['password'].toString();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _loginController,
              decoration: InputDecoration(
                labelText: 'Login',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _updateAccountData,
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}