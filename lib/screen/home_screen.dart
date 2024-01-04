import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/providers/place_provider.dart';
import 'package:places/screen/add_place_screen.dart';
import 'package:places/screen/place_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(placeProvider.notifier).loadPlace();
  }

  @override
  Widget build(BuildContext context) {
    final listPlace = ref.watch(placeProvider);

    Widget content = Center(
      child: Text(
        "No places",
        style: TextStyle(color: Colors.white),
      ),
    );

    if (!listPlace.isEmpty) {
      content = ListView.builder(
        itemCount: listPlace.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    PlaceDetailScreen(placeModel: listPlace[index]),
              ),
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              radius: 26,
              backgroundImage: FileImage(listPlace[index].image),
            ),
            title: Text(listPlace[index].title),
          ),
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Places'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => AddPlaceScreen(),
                  ),
                );
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: _placesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return content;
            },
          ),
        ));
  }
}
