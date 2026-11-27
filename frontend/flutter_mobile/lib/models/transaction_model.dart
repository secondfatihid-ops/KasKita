class TransactionModel {
  final int id;
  final int userId;
  final int categoryId;
  final double amount;
  final String? description;
  final String? receiptImage;
  final String? createdAt;
  
  // Field tambahan dari hasil JOIN di backend (opsional)
  final String? userName;
  final String? categoryName;
  final String? categoryType;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    this.description,
    this.receiptImage,
    this.createdAt,
    this.userName,
    this.categoryName,
    this.categoryType,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? json['userId'] ?? 0,
      categoryId: json['category_id'] ?? json['categoryId'] ?? 0,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      description: json['description'],
      receiptImage: json['receipt_image'] ?? json['receiptImage'],
      createdAt: json['created_at'] ?? json['createdAt'],
      userName: json['user_name'] ?? json['userName'],
      categoryName: json['category_name'] ?? json['categoryName'],
      categoryType: json['category_type'] ?? json['categoryType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'description': description,
      'receipt_image': receiptImage,
      'created_at': createdAt,
    };
  }
}