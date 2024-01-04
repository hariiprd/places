import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/models/place_model.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  return await sql.openDatabase(path.join(dbPath, "places.db"),
      onCreate: (db, version) {
    return db.execute(
        "CREATE TABLE places (id TEXT PRIMARY KEY, title TEXT, imagePath TEXT)");
  }, version: 1);
}

class PlaceNotifier extends StateNotifier<List<PlaceModel>> {
  PlaceNotifier() : super(const []);

  Future<void> loadPlace() async {
    final db = await _getDatabase();
    final datas = await db.query("places");
    final places = datas
        .map((e) => PlaceModel(
              id: e["id"] as String,
              title: e["title"] as String,
              image: File(e["imagePath"] as String),
            ))
        .toList();

    state = places;
  }

  void addPlace(PlaceModel placeModel) async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(placeModel.image.path);
    placeModel.image =
        await placeModel.image.copy("${appDir.path}/${fileName}");

    final db = await _getDatabase();
    db.insert("places", {
      "id": placeModel.id,
      "title": placeModel.title,
      "imagePath": placeModel.image.path
    });
    state = [...state, placeModel];
  }
}

final placeProvider = StateNotifierProvider<PlaceNotifier, List<PlaceModel>>(
    (ref) => PlaceNotifier());
// final placeProvider = Provider((ref) {
//   return placesList;
// });
