class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final String deliveryAddress;
  final String paymentMethod;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String? trackingId;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
    this.trackingId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      'status': status.toString(),
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'trackingId': trackingId,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      items: (map['items'] as List<dynamic>)
          .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      deliveryAddress: map['deliveryAddress'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      orderDate: DateTime.parse(map['orderDate']),
      deliveryDate: map['deliveryDate'] != null 
          ? DateTime.parse(map['deliveryDate']) 
          : null,
      trackingId: map['trackingId'],
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final String quantity;
  final int itemCount;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.itemCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
      'itemCount': itemCount,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? '',
      itemCount: map['itemCount'] ?? 1,
    );
  }

  double get totalPrice => price * itemCount;
}

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  outForDelivery,
  delivered,
  cancelled,
  refunded,
}

class FeedbackModel {
  final String id;
  final String userId;
  final String? userName;
  final int rating;
  final String feedbackText;
  final String? email;
  final DateTime createdAt;

  FeedbackModel({
    required this.id,
    required this.userId,
    this.userName,
    required this.rating,
    required this.feedbackText,
    this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'feedbackText': feedbackText,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'],
      rating: map['rating'] ?? 0,
      feedbackText: map['feedbackText'] ?? '',
      email: map['email'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}