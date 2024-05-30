class SummonerId {
  String id;

  SummonerId({required this.id});

  factory SummonerId.fromJson(Map<String, dynamic> json) {
    return SummonerId(
      id: json['id'],
    );
  }
}
