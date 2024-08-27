import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

import 'data.dart';

class FetchImage extends StatefulWidget {
  @override
  _FetchImageState createState() => _FetchImageState();
}

class _FetchImageState extends State<FetchImage> {
  List<Map<String, dynamic>>? _images;

  Future<void> _fetchImages() async {
    try {
      // Connect to the database
      var db = Mysql();
      MySqlConnection connection = await db.getConnection();

      // Retrieve images and names from the database
      var results = await connection.query('SELECT image, name FROM data');

      List<Map<String, dynamic>> images = [];

      for (var row in results) {
        // Convert the retrieved Blob to Uint8List
        Blob blob = row['image'];
        List<int> imageBytes = blob.toBytes();
        Uint8List imageData = imageBytes as Uint8List;

        // Get the name
        String name = row['name'];

        // Add the image and name to the list
        images.add({'image': imageData, 'name': name});
      }

      setState(() {
        _images = images;
      });

      await connection.close();
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fetch Images')),
      body: Center(
        child: Column(
          children: [
            if (_images != null)
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5, // 5 images per row
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: _images!.length,
                  itemBuilder: (context, index) {
                    final data = _images![index];
                    return Column(
                      children: [
                        Image.memory(
                          data['image'],
                          width: 70,
                          height: 70,
                        ),
                        SizedBox(height: 5),
                        Text(
                          data['name'],
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ElevatedButton(
              onPressed: _fetchImages,
              child: Text('Fetch Images'),
            ),
          ],
        ),
      ),
    );
  }
}
