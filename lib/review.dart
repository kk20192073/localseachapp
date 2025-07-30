class Review {
  final String id;
  final String content;
  final double mapX;
  final double mapY;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.content,
    required this.mapX,
    required this.mapY,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      content: json['content'],
      mapX: (json['mapX'] as num).toDouble(),
      mapY: (json['mapY'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'mapX': mapX,
      'mapY': mapY,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
