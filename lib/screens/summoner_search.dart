import 'package:flutter/material.dart';

import '../data/status_class.dart'; // Import the StatusApi class
import '../model/id_model.dart';
import '../model/status_model.dart'; // Import the Status class
import '../model/summoner_model.dart';

class SummonerSearch extends StatefulWidget {
  @override
  _SummonerSearchState createState() => _SummonerSearchState();
}

class _SummonerSearchState extends State<SummonerSearch> {
  final TextEditingController _gameNameController = TextEditingController();
  final TextEditingController _tagLineController = TextEditingController();
  String _puuid = '';
  String _summonerId = '';
  List<Status> _statusList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _searchSummoner() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final summoner = await SummonerApi.getSummoner(
          _gameNameController.text,
          _tagLineController.text,
          'RGAPI-c7289224-b3eb-4093-ba43-a3adb2e26a16');

      final summonerId = await SummonerIdApi.getSummonerId(
          summoner.puuid, 'RGAPI-c7289224-b3eb-4093-ba43-a3adb2e26a16');

      final statusList = await StatusApi.getStatus(summonerId.id,
          'RGAPI-c7289224-b3eb-4093-ba43-a3adb2e26a16'); // Fetch status list

      setState(() {
        _puuid = summoner.puuid;
        _summonerId = summonerId.id;
        _statusList = statusList; // Set status list
        _isLoading = false;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to fetch summoner: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summoner Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _gameNameController,
              decoration: InputDecoration(labelText: 'Game Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _tagLineController,
              decoration: InputDecoration(labelText: 'Tag Line'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _searchSummoner,
              child: Text('Search'),
            ),
            SizedBox(height: 16.0),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Text(_errorMessage)
                    : _puuid.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('PUUID: $_puuid'),
                              SizedBox(height: 16.0),
                              _summonerId.isNotEmpty
                                  ? Text('Summoner ID: $_summonerId')
                                  : Container(),
                              SizedBox(height: 16.0),
                              _statusList.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: _statusList
                                          .map((status) => Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Tier: ${status.tier}'),
                                                  Text('Rank: ${status.rank}'),
                                                  Text(
                                                      'League Points: ${status.leaguePoints}'),
                                                  Text('Wins: ${status.wins}'),
                                                  Text(
                                                      'Losses: ${status.losses}'),
                                                  Divider(),
                                                ],
                                              ))
                                          .toList(),
                                    )
                                  : Container(),
                            ],
                          )
                        : Container(),
          ],
        ),
      ),
    );
  }
}
