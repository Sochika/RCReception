import 'package:attendance/constants.dart';
import 'package:attendance/screens/dashboard/add_colombe.dart';
import 'package:attendance/screens/dashboard/settings.dart';
import 'package:attendance/screens/main/add_colombe.dart';
import 'package:attendance/screens/main/add_screen.dart';
import 'package:attendance/screens/main/list_colombe_screen.dart';
import 'package:attendance/screens/main/list_screen.dart';
import 'package:attendance/screens/main/main_screen.dart';
import 'package:attendance/screens/main/mark_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

import 'data/sqlite.dart';



void main() {
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> _setDefaultValues;

  @override
  void initState() {
    super.initState();
    _setDefaultValues = setDefaultValues();
  }

  Future<void> setDefaultValues() async {
    final db = DatabaseHelper();
    var settings = await db.getSetting();

    if (settings != null) {
      setState(() {
        settingConst = settings;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DatabaseHelper db = DatabaseHelper();
    db.open();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AMORC Attendance',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      routes: {
        '/markAttend': (context) => const MarkScreen(),
        '/addMember': (context) => const AddScreen(),
        '/listMember': (context) => const ListScreen(),
        '/addColombe': (context) => const AddColombeScreen(),
        '/listColombe': (context) => const ListColombeScreen(),
        '/settings': (context) => const Setting(),
      },
      home: const MainScreen(),
    );
  }
}

