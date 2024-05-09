class Summoner {
  String puuid;

  Summoner({required this.puuid});

  factory Summoner.fromJson(Map<String, dynamic> json) {
    return Summoner(
      puuid: json['puuid'],
    );
  }
}
