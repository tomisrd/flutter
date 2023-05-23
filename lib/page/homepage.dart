import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HomePage extends StatelessWidget {
  Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'your_database.db');
    return openDatabase(path, version: 1,
        onCreate: (db, version) {
          db.execute('CREATE TABLE users (id INTEGER PRIMARY KEY, login TEXT, password TEXT)');
        });
  }

  void _showUserCredentials(BuildContext context) async {
    final database = await _openDatabase();
    final results = await database.query('users');
    if (results.isNotEmpty) {
      for (final result in results) {
        final id = result['id'];
        final login = result['login'];
        final password = result['password'];
        print('ID: $id, Login: $login, Password: $password');
      }
    } else {
      print('Aucun utilisateur enregistré dans la base de données.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('S\'enregistrer'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Se connecter'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _showUserCredentials(context),
              child: Text('Afficher les informations des utilisateurs'),
            ),
          ],
        ),
      ),
    );
  }
}