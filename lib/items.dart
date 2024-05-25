import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tft_synk/app_constants.dart';

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
                return Container(
                  margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Card(
                    color: AppColors.primaryVariant,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Image.asset(
                                'assets/items/${item.image}',
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: AppTextStyles.headline3BeaufortforLOL,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.description,
                            style: AppTextStyles.bodyText5Spiegel,
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                for (int i = 0;
                                    i < item.components.length;
                                    i++) ...[
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Image.asset(
                                      'assets/components/${item.components[i]}.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  if (i < item.components.length - 1)
                                    const Text(
                                      " + ",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
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
