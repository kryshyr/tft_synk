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
  // String _summonerId = '';
  List<Status> _statusList = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String API_KEY = 'RGAPI-13a919d2-12bf-423e-b556-f600677e1519';

// Search for a summoner and fetch data
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
        // _summonerId = summonerId.id;
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
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.secondary),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Color.fromRGBO(200, 155, 60, 1),
              height: 1.0,
            )),
        title: const Text(
          'Summoner Search',
          style: AppTextStyles.headline1BeaufortforLOL,
        ),
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
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.tertiaryAccent),
                ),
                prefixIcon: Icon(Icons.person, color: AppColors.secondary),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              style: AppTextStyles.bodyText6Spiegel,
              controller: _tagLineController,
              decoration: const InputDecoration(
                hintText: 'Tag line',
                hintStyle: TextStyle(
                    color: AppColors.hintText,
                    fontFamily: 'Spiegel',
                    fontWeight: FontWeight.normal),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.tertiaryAccent),
                ),
                prefixIcon: Icon(Icons.tag, color: AppColors.secondary),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _searchSummoner,
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.secondary,
                backgroundColor: AppColors.primaryVariant,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(color: AppColors.secondary, width: 2),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search,
                    color: AppColors.secondary,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Search',
                    style: AppTextStyles.headline5BeaufortforLOL,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
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
                                          .map((status) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Card(
                                                  color: AppColors.background,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    side: const BorderSide(
                                                      color:
                                                          AppColors.secondary,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(Icons.person,
                                                                color: AppColors
                                                                    .secondary),
                                                            SizedBox(width: 8),
                                                            Text(
                                                              _gameNameController
                                                                  .text,
                                                              style: AppTextStyles
                                                                  .headline5BeaufortforLOL,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 8),
                                                        Row(
                                                          children: [
                                                            Icon(Icons.tag,
                                                                color: AppColors
                                                                    .secondary),
                                                            SizedBox(width: 8),
                                                            Text(
                                                              _tagLineController
                                                                  .text,
                                                              style: AppTextStyles
                                                                  .headline5BeaufortforLOL,
                                                            ),
                                                          ],
                                                        ),
                                                        Divider(),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      'Tier: ${status.tier}',
                                                                      style: AppTextStyles
                                                                          .bodyText6Spiegel),
                                                                  Text(
                                                                      'Rank: ${status.rank}',
                                                                      style: AppTextStyles
                                                                          .bodyText6Spiegel),
                                                                  Text(
                                                                      'League Points: ${status.leaguePoints}',
                                                                      style: AppTextStyles
                                                                          .bodyText6Spiegel),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      'Wins: ${status.wins}',
                                                                      style: AppTextStyles
                                                                          .bodyText6Spiegel),
                                                                  Text(
                                                                      'Losses: ${status.losses}',
                                                                      style: AppTextStyles
                                                                          .bodyText6Spiegel),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
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
