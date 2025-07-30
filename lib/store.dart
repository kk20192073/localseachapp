class Store {
  final String title;
  final String category;
  final String roadAddress;
  final double? mapX;
  final double? mapY;

  const Store({
    required this.title,
    required this.category,
    required this.roadAddress,
    this.mapX,
    this.mapY,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      title: (json['title'] ?? '').replaceAll(RegExp(r'<[^>]*>'), ''),
      category: json['category'] ?? '',
      roadAddress: json['roadAddress'] ?? '',
      mapX: double.tryParse(json['mapx']?.toString() ?? ''),
      mapY: double.tryParse(json['mapy']?.toString() ?? ''),
    );
  }
}
