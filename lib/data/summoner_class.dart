class Summoner {
  // string variable to hold the summoner's PUUID
  String puuid;

  Summoner({required this.puuid});

  factory Summoner.fromJson(Map<String, dynamic> json) {
    return Summoner(
      puuid: json['puuid'],
    );
  }
}
