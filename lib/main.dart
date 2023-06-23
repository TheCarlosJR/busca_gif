
import 'package:flutter/material.dart';
import 'package:busca_gif_aula/pages/homepage.dart';
import 'package:busca_gif_aula/pages/gifpage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
    theme: ThemeData(
      hintColor: Colors.white,
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber),
        ),
        labelStyle: TextStyle(color: Colors.white70),
      ),
    ),
  ));
}

