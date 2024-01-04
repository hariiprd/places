import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/models/place_model.dart';
import 'package:places/providers/place_provider.dart';
import 'package:places/widget/image_input.dart';
import 'package:places/widget/location_input.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final GlobalKey<FormState> form = GlobalKey();

  File? _selectedImage;

  var _txtTitle = "";

  void saveClick() {
    if (form.currentState!.validate() || _selectedImage != null) {
      form.currentState!.save();
      PlaceModel newPlace =
          PlaceModel(title: _txtTitle, image: _selectedImage!);
      ref.read(placeProvider.notifier).addPlace(newPlace);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Place"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    label: Text("Title"),
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Isi title!";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _txtTitle = val!;
                  },
                ),
                SizedBox(height: 10),
                ImageInput(onPickImage: (image) {
                  _selectedImage = image;
                }),
                SizedBox(height: 10),
                LocationInput(),
                SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: saveClick,
                  icon: Icon(Icons.add),
                  label: Text("Add Places"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
