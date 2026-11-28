class CategoryModel {
  final int id;
  final String name;
  final String type; // 'income' atau 'expense'
  final String? createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? 'income',
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'created_at': createdAt,
    };
  }
}