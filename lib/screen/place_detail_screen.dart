import 'package:flutter/material.dart';
import 'package:places/models/place_model.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.placeModel});
  final PlaceModel placeModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(placeModel.title)),
        body: Stack(
          children: [
            Image.file(
              placeModel.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            )
          ],
        ));
  }
}
