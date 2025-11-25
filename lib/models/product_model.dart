class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String quantity;
  final String imagePath;
  final String category;
  final String section; // 'exclusive' or 'best_selling'
  final bool inStock;
  final int stockCount;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.imagePath,
    required this.category,
    required this.section,
    this.inStock = true,
    this.stockCount = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'imagePath': imagePath,
      'category': category,
      'section': section,
      'inStock': inStock,
      'stockCount': stockCount,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? '',
      imagePath: map['imagePath'] ?? '',
      category: map['category'] ?? '',
      section: map['section'] ?? '',
      inStock: map['inStock'] ?? true,
      stockCount: map['stockCount'] ?? 0,
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }
}

class CartItem {
  final String id;
  final String userId;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final String quantity;
  final int itemCount;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.itemCount,
    required this.addedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
      'itemCount': itemCount,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? '',
      itemCount: map['itemCount'] ?? 1,
      addedAt: DateTime.parse(map['addedAt']),
    );
  }

  double get totalPrice => price * itemCount;
}

class FavoriteItem {
  final String id;
  final String userId;
  final String productId;
  final DateTime addedAt;

  FavoriteItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.addedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory FavoriteItem.fromMap(Map<String, dynamic> map) {
    return FavoriteItem(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      productId: map['productId'] ?? '',
      addedAt: DateTime.parse(map['addedAt']),
    );
  }
}