import 'dart:io';
import 'dart:typed_data';

import 'package:crud_sqllite/imageFetching.dart';
import 'package:crud_sqllite/imageUpload.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image/image.dart' as ui;

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LMS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          toolbarHeight: 70,
          backgroundColor: Color.fromARGB(255, 49, 27, 146),
          foregroundColor: Colors.white,
        ),
      ),
      home: ImageUpload(),
    );
  }
}
