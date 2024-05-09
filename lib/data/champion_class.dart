class Champion {
  String id;
  String name;
  int tier;
  String sprite; // Add sprite field

  Champion({
    required this.id,
    required this.name,
    required this.tier,
    required this.sprite, // Add sprite parameter
  });

  factory Champion.fromJson(Map<String, dynamic> json) {
    // Extract the image field
    final Map<String, dynamic> image = json['image'];

    return Champion(
      id: json['id'],
      name: json['name'],
      tier: json['tier'],
      sprite: image['sprite'],
    );
  }
}
