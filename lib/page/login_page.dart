import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'profil_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  void _loginUser(BuildContext context) async {
    final database = await _openDatabase();
    final login = _loginController.text;
    final password = _passwordController.text;
    final results = await database.query(
      'users',
      where: 'login = ? AND password = ?',
      whereArgs: [login, password],
    );
    if (results.isNotEmpty) {
      final accountId = results.first['id'] as int; // Récupère l'ID du compte connecté
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage(accountId: accountId)),
      );
    } else {
      print('Login ou mot de passe incorrect.');
      // Affichez un message d'erreur à l'utilisateur
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Se connecter'),
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
              onPressed: () => _loginUser(context), // Passer context en tant qu'argument
              child: Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}