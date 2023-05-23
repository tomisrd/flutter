import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'login_page.dart'; // Importez la page de connexion

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _createTable(Database db, int version) {
    db.execute('CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, login TEXT, password TEXT)');
  }

  Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'your_database.db');
    return openDatabase(path, version: 1, onCreate: _createTable);
  }

  void _saveUserData() async {
    final database = await _openDatabase();
    final user = {
      'login': _loginController.text,
      'password': _passwordController.text,
    };
    await database.insert('users', user);
    print('Données utilisateur enregistrées avec succès !');
  }

  void _fetchUserCredentials() async {
    final database = await _openDatabase();
    final results = await database.query('users');
    if (results.isNotEmpty) {
      for (final result in results) {
        final login = result['login'];
        final password = result['password'];
        print('Login: $login, Password: $password');
      }
    } else {
      print('Aucun utilisateur enregistré dans la base de données.');
    }
  }

  void _registerUser(BuildContext context) async {
    final database = await _openDatabase();
    final user = {
      'login': _loginController.text,
      'password': _passwordController.text,
    };
    await database.insert('users', user);
    print('Utilisateur inscrit avec succès !');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('S\'enregistrer'),
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
              onPressed: () => _registerUser(context),
              child: Text('S\'enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}