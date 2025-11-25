import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  // Use a unique ID for the cart item itself (can be Firestore document ID)
  final String cartItemId;
  // Link to the actual product (foreign key)
  final String productId; 
  final String name;
  final String imageUrl;
  final double price; // Price at the time of adding to cart
  final int quantity;
  final String unit; // e.g., "1kg", "500g", "1pc"

  CartModel({
    required this.cartItemId,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.unit,
  });

  // Convert CartModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'unit': unit,
    };
  }

  // Create CartModel from Firestore document map
  factory CartModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CartModel(
      cartItemId: documentId, // Use the document ID as the CartItem ID
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      unit: map['unit'] ?? '',
    );
  }

  // Create CartModel from Firestore DocumentSnapshot
  factory CartModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartModel.fromMap(data, doc.id);
  }
}