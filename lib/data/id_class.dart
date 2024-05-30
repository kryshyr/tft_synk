//SummonerID class
class SummonerId {
  // String to hold the summoner ID
  String id;

  // constructor
  SummonerId({required this.id});

  factory SummonerId.fromJson(Map<String, dynamic> json) {
    return SummonerId(
      // Extract the 'id' field from the JSON map
      id: json['id'],
    );
  }
}
