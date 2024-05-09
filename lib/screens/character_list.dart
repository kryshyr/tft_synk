import 'dart:convert';

import 'package:flutter/material.dart';

import '../data/champion_class.dart';
import '../model/character_model.dart';

class CharacterList extends StatefulWidget {
  const CharacterList({Key? key}) : super(key: key);

  @override
  _CharacterListState createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  late List<Champion> characterList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCharactersFromApi();
  }

  Future<void> getCharactersFromApi() async {
    try {
      final response = await ChampionApi.getCharacters();
      final Map<String, dynamic> data = json.decode(response.body);
      List<Champion> champions = [];

      data['data'].forEach((key, value) {
        champions.add(Champion.fromJson(value));
      });

      setState(() {
        characterList = champions;
        isLoading = false;
      });

      // Print the contents of characterList
      print('Printing champion list:');
      characterList.forEach((champion) {
        print(
            'ID: ${champion.id}, Name: ${champion.name}, Tier: ${champion.tier}, Image: ${champion.sprite}');
      });
    } catch (e) {
      print('Failed to fetch champions: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("League of Legends Champions"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : characterList.isNotEmpty
              ? ListView.builder(
                  itemCount: characterList.length,
                  itemBuilder: (context, index) {
                    final champion = characterList[index];
                    return ListTile(
                      title: Text(champion.name),
                      subtitle: Text("Tier: ${champion.tier}"),
                      leading: Image.network(
                          'https://ddragon.leagueoflegends.com/cdn/14.9.1/img/tft-champion/${champion.sprite}',
                          width: 48,
                          height: 48),
                    );
                  },
                )
              : Center(
                  child: Text('No champions found.'),
                ),
    );
  }
}
