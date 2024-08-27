import 'dart:io';
import 'dart:typed_data';
import 'package:crud_sqllite/data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysql1/mysql1.dart';

class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _image;

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    // Read image as bytes
    Uint8List imageBytes = await _image!.readAsBytes();

    // Connect to the database
    var db = Mysql();
    MySqlConnection connection = await db.getConnection();

    // Insert the image into the database (without a filename)
    var result = await connection.query(
      'INSERT INTO users (image) VALUES (?)',
      [imageBytes],
    );

    if (result.insertId != null) {
      print('Image uploaded successfully with ID: ${result.insertId}');
    } else {
      print('Image upload failed');
    }

    await connection.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Upload')),
      body: Center(
        child: Column(
          children: [
            if (_image != null)
              Image.file(
                _image!,
                height: 150,
              ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
