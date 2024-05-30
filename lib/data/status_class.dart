class Status {
  final String tier;
  final String rank;
  final int wins;
  final int losses;
  final int leaguePoints;

  Status({
    required this.tier,
    required this.rank,
    required this.leaguePoints,
    required this.wins,
    required this.losses,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      tier: json['tier'],
      rank: json['rank'],
      leaguePoints: json['leaguePoints'],
      wins: json['wins'],
      losses: json['losses'],
    );
  }
}
