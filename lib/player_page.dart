import 'package:flutter/material.dart';

import '../data/status_class.dart';
import '../model/id_model.dart';
import '../model/status_model.dart';
import '../model/summoner_model.dart';
import 'app_constants.dart';

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
  String API_KEY = 'RGAPI-13a919d2-12bf-423e-b556-f600677e1519';

  Future<void> _searchSummoner() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final summoner = await SummonerApi.getSummoner(
          _gameNameController.text, _tagLineController.text, API_KEY);

      final summonerId =
          await SummonerIdApi.getSummonerId(summoner.puuid, API_KEY);

      final statusList = await StatusApi.getStatus(
          summonerId.id, API_KEY); // Fetch status list

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
              style: AppTextStyles.bodyText6Spiegel,
              controller: _gameNameController,
              decoration: const InputDecoration(
                hintText: 'Game Name',
                hintStyle: TextStyle(
                    color: AppColors.hintText,
                    fontFamily: 'Spiegel',
                    fontWeight: FontWeight.normal),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              style: AppTextStyles.bodyText6Spiegel,
              controller: _tagLineController,
              decoration: const InputDecoration(
                hintText: 'Tag line',
                hintStyle: TextStyle(
                    color: AppColors.hintText,
                    fontFamily: 'Spiegel',
                    fontWeight: FontWeight.normal),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _searchSummoner,
              child: Text(
                'Search',
              ),
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
                              _statusList.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: _statusList
                                          .map((status) => Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Tier: ${status.tier}',
                                                      style: AppTextStyles
                                                          .bodyText6Spiegel),
                                                  Text('Rank: ${status.rank}',
                                                      style: AppTextStyles
                                                          .bodyText6Spiegel),
                                                  Text(
                                                      'League Points: ${status.leaguePoints}',
                                                      style: AppTextStyles
                                                          .bodyText6Spiegel),
                                                  Text('Wins: ${status.wins}',
                                                      style: AppTextStyles
                                                          .bodyText6Spiegel),
                                                  Text(
                                                      'Losses: ${status.losses}',
                                                      style: AppTextStyles
                                                          .bodyText6Spiegel),
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
