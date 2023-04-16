import 'package:flutter/material.dart';

class FullScreenImagePreview extends StatelessWidget {
  final String heroTag;
  final String imageUrl;

  FullScreenImagePreview({required this.heroTag, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Back button to return to the previous screen
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: Image.network(
            imageUrl,
            fit: BoxFit.fitWidth,
            // Use MediaQuery to get the full height and width of the screen
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }
}