import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// item.dart
class Item {
  final String id;
  final String name;
  final String image;
  final String description;
  final List<String> components;

  Item({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.components,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      components: List<String>.from(json['components']),
    );
  }
}

Future<List<Item>> loadItems() async {
  final jsonString = await rootBundle.loadString('assets/data/items.json');
  final List<dynamic> jsonResponse = json.decode(jsonString);
  return jsonResponse.map((json) => Item.fromJson(json)).toList();
}

class ItemsTab extends StatefulWidget {
  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsTab> {
  late Future<List<Item>> items;

  @override
  void initState() {
    super.initState();
    items = loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Item>>(
        future: items,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return Center(
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Image.asset('assets/items/${item.image}'),
                          title: Text(item.name),
                          subtitle: Text(item.description),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            for (final component in item.components)
                              Row(
                                children: [
                                  Image.asset('assets/items/$component'),
                                  const SizedBox(width: 8),
                                  Text("+"),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
