import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/models/user_model.dart';
import 'package:grocery_app/models/product_model.dart';
import 'package:grocery_app/models/order_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ==================== USER OPERATIONS ====================
  
  // Create user document in Firestore
  Future<void> createUserDocument(User user, String name, {String? phone}) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': user.email ?? '',
        'phone': phone,
        'profileImage': null,
        'addresses': [],
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': null,
      });
    } catch (e) {
      print('Error creating user document: $e');
      rethrow;
    }
  }

  // Get user data
  Future<UserModel?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? phone,
    String? profileImage,
  }) async {
    try {
      Map<String, dynamic> updates = {
        'updatedAt': DateTime.now().toIso8601String(),
      };
      
      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (profileImage != null) updates['profileImage'] = profileImage;

      await _firestore.collection('users').doc(userId).update(updates);
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  // Add address
  Future<void> addAddress(String userId, Address address) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'addresses': FieldValue.arrayUnion([address.toMap()]),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error adding address: $e');
      rethrow;
    }
  }

  // ==================== PRODUCT OPERATIONS ====================
  
  // Get all products
  Stream<List<ProductModel>> getProducts() {
    return _firestore.collection('products').snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data()))
          .toList(),
    );
  }

  // Get products by section
  Stream<List<ProductModel>> getProductsBySection(String section) {
    return _firestore
        .collection('products')
        .where('section', isEqualTo: section)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProductModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Get products by category
  Stream<List<ProductModel>> getProductsByCategory(String category) {
    return _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProductModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Get single product
  Future<ProductModel?> getProduct(String productId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting product: $e');
      return null;
    }
  }

  // ==================== CART OPERATIONS ====================
  
  // Add to cart
  Future<void> addToCart(String userId, CartItem cartItem) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartItem.id)
          .set(cartItem.toMap());
    } catch (e) {
      print('Error adding to cart: $e');
      rethrow;
    }
  }

  // Get cart items
  Stream<List<CartItem>> getCartItems(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CartItem.fromMap(doc.data()))
              .toList(),
        );
  }

  // Update cart item quantity
  Future<void> updateCartItemQuantity(String userId, String cartItemId, int newCount) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartItemId)
          .update({'itemCount': newCount});
    } catch (e) {
      print('Error updating cart item: $e');
      rethrow;
    }
  }

  // Remove from cart
  Future<void> removeFromCart(String userId, String cartItemId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartItemId)
          .delete();
    } catch (e) {
      print('Error removing from cart: $e');
      rethrow;
    }
  }

  // Clear cart
  Future<void> clearCart(String userId) async {
    try {
      final cartItems = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();
      
      for (var doc in cartItems.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error clearing cart: $e');
      rethrow;
    }
  }

  // ==================== FAVORITE OPERATIONS ====================
  
  // Add to favorites
  Future<void> addToFavorites(String userId, String productId) async {
    try {
      final favoriteId = '${userId}_$productId';
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(favoriteId)
          .set({
        'id': favoriteId,
        'userId': userId,
        'productId': productId,
        'addedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error adding to favorites: $e');
      rethrow;
    }
  }

  // Remove from favorites
  Future<void> removeFromFavorites(String userId, String productId) async {
    try {
      final favoriteId = '${userId}_$productId';
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(favoriteId)
          .delete();
    } catch (e) {
      print('Error removing from favorites: $e');
      rethrow;
    }
  }

  // Get favorite products
  Stream<List<ProductModel>> getFavoriteProducts(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .asyncMap((snapshot) async {
      List<ProductModel> products = [];
      
      print('DEBUG: Found ${snapshot.docs.length} favorites in Firebase');
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final productId = data['productId'];
        
        print('DEBUG: Processing favorite productId: $productId');
        
        // First try to get from Firestore products collection
        var product = await getProduct(productId);
        
        // If not found in Firestore, create from hardcoded data if available
        if (product == null) {
          print('DEBUG: Product $productId not in Firestore, creating from local data');
          product = await _getProductFromLocalData(productId);
        }
        
        if (product != null) {
          products.add(product);
          print('DEBUG: Added product ${product.name} to favorites list');
        } else {
          print('DEBUG: Product $productId not found anywhere');
        }
      }
      
      print('DEBUG: Returning ${products.length} favorite products');
      return products;
    });
  }

  // Helper to create ProductModel from hardcoded data
  Future<ProductModel?> _getProductFromLocalData(String productId) async {
    // Hardcoded products data that matches your home_screen.dart
    final Map<String, Map<String, dynamic>> localProducts = {
      'product_1': {
        'id': 'product_1',
        'name': 'Organic Bananas',
        'description': 'Premium organic bananas, naturally sweet and packed with potassium.',
        'price': 4.99,
        'quantity': '7pcs',
        'imagePath': 'assets/images/banana.jpg',
        'category': 'Fresh Fruits & Vegetable',
        'section': 'exclusive',
        'inStock': true,
        'stockCount': 100,
        'rating': 4.5,
        'reviewCount': 25,
      },
      'product_2': {
        'id': 'product_2',
        'name': 'Red Apple',
        'description': 'Crisp and juicy red apples, perfect for snacking.',
        'price': 4.99,
        'quantity': '1kg',
        'imagePath': 'assets/images/apple.jpg',
        'category': 'Fresh Fruits & Vegetable',
        'section': 'exclusive',
        'inStock': true,
        'stockCount': 80,
        'rating': 4.7,
        'reviewCount': 30,
      },
      'product_6': {
        'id': 'product_6',
        'name': 'Organic Cucumber',
        'description': 'Fresh organic cucumbers, crisp and refreshing.',
        'price': 1.99,
        'quantity': '1pc',
        'imagePath': 'assets/images/cucumber.jpg',
        'category': 'Fresh Fruits & Vegetable',
        'section': 'exclusive',
        'inStock': true,
        'stockCount': 50,
        'rating': 4.3,
        'reviewCount': 15,
      },
      'product_3': {
        'id': 'product_3',
        'name': 'Bell Pepper Red',
        'description': 'Crisp and vibrant red bell peppers, rich in vitamins A and C.',
        'price': 4.99,
        'quantity': '1kg',
        'imagePath': 'assets/images/bell_paper.jpeg',
        'category': 'Fresh Fruits & Vegetable',
        'section': 'best_selling',
        'inStock': true,
        'stockCount': 60,
        'rating': 4.8,
        'reviewCount': 40,
      },
      'product_4': {
        'id': 'product_4',
        'name': 'Ginger',
        'description': 'Fresh ginger root, perfect for cooking and tea.',
        'price': 4.99,
        'quantity': '250gm',
        'imagePath': 'assets/images/ginger.jpeg',
        'category': 'Fresh Fruits & Vegetable',
        'section': 'best_selling',
        'inStock': true,
        'stockCount': 45,
        'rating': 4.6,
        'reviewCount': 20,
      },
      'product_5': {
        'id': 'product_5',
        'name': 'Watermelon',
        'description': 'Sweet and juicy watermelon, perfect for summer.',
        'price': 3.50,
        'quantity': '1pc',
        'imagePath': 'assets/images/watermelon.jpg',
        'category': 'Fresh Fruits & Vegetable',
        'section': 'best_selling',
        'inStock': true,
        'stockCount': 30,
        'rating': 4.9,
        'reviewCount': 50,
      },
    };

    if (localProducts.containsKey(productId)) {
      final data = localProducts[productId]!;
      return ProductModel(
        id: data['id'],
        name: data['name'],
        description: data['description'],
        price: data['price'],
        quantity: data['quantity'],
        imagePath: data['imagePath'],
        category: data['category'],
        section: data['section'],
        inStock: data['inStock'],
        stockCount: data['stockCount'],
        rating: data['rating'],
        reviewCount: data['reviewCount'],
        createdAt: DateTime.now(),
      );
    }
    
    return null;
  }

  // Check if product is favorite
  Future<bool> isFavorite(String userId, String productId) async {
    try {
      final favoriteId = '${userId}_$productId';
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(favoriteId)
          .get();
      return doc.exists;
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }

  // ==================== ORDER OPERATIONS ====================
  
  // Create order
  Future<String> createOrder(OrderModel order) async {
    try {
      await _firestore.collection('orders').doc(order.id).set(order.toMap());
      
      // Clear cart after order
      await clearCart(order.userId);
      
      return order.id;
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }

  // Get user orders
  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Get order by ID
  Future<OrderModel?> getOrder(String orderId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('orders').doc(orderId).get();
      if (doc.exists) {
        return OrderModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting order: $e');
      return null;
    }
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status.toString(),
      });
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }

  // ==================== FEEDBACK OPERATIONS ====================
  
  // Submit feedback
  Future<void> submitFeedback(FeedbackModel feedback) async {
    try {
      await _firestore.collection('feedback').doc(feedback.id).set(feedback.toMap());
    } catch (e) {
      print('Error submitting feedback: $e');
      rethrow;
    }
  }

  // Get all feedback (admin only)
  Stream<List<FeedbackModel>> getAllFeedback() {
    return _firestore
        .collection('feedback')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => FeedbackModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // ==================== ADMIN OPERATIONS (FOR INITIAL SETUP) ====================
  
  // Initialize products in Firestore (Run this once to populate database)
  Future<void> initializeProducts() async {
    try {
      final List<Map<String, dynamic>> initialProducts = [
        {
          'id': 'product_1',
          'name': 'Organic Bananas',
          'description': 'Premium organic bananas, naturally sweet and packed with potassium. Perfect for smoothies or a quick, healthy snack.',
          'price': 4.99,
          'quantity': '7pcs',
          'imagePath': 'assets/images/banana.jpg',
          'category': 'Fresh Fruits & Vegetable',
          'section': 'exclusive',
          'inStock': true,
          'stockCount': 100,
          'rating': 4.5,
          'reviewCount': 25,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': null,
        },
        {
          'id': 'product_2',
          'name': 'Red Apple',
          'description': 'Crisp and juicy red apples, perfect for snacking.',
          'price': 4.99,
          'quantity': '1kg',
          'imagePath': 'assets/images/apple.jpg',
          'category': 'Fresh Fruits & Vegetable',
          'section': 'exclusive',
          'inStock': true,
          'stockCount': 80,
          'rating': 4.7,
          'reviewCount': 30,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': null,
        },
        {
          'id': 'product_6',
          'name': 'Organic Cucumber',
          'description': 'Fresh organic cucumbers, crisp and refreshing.',
          'price': 1.99,
          'quantity': '1pc',
          'imagePath': 'assets/images/cucumber.jpg',
          'category': 'Fresh Fruits & Vegetable',
          'section': 'exclusive',
          'inStock': true,
          'stockCount': 50,
          'rating': 4.3,
          'reviewCount': 15,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': null,
        },
        {
          'id': 'product_3',
          'name': 'Bell Pepper Red',
          'description': 'Crisp and vibrant red bell peppers, rich in vitamins A and C. Ideal for salads, stir-fries, and adding a sweet crunch to any dish.',
          'price': 4.99,
          'quantity': '1kg',
          'imagePath': 'assets/images/bell_paper.jpeg',
          'category': 'Fresh Fruits & Vegetable',
          'section': 'best_selling',
          'inStock': true,
          'stockCount': 60,
          'rating': 4.8,
          'reviewCount': 40,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': null,
        },
        {
          'id': 'product_4',
          'name': 'Ginger',
          'description': 'Fresh ginger root, perfect for cooking and tea.',
          'price': 4.99,
          'quantity': '250gm',
          'imagePath': 'assets/images/ginger.jpeg',
          'category': 'Fresh Fruits & Vegetable',
          'section': 'best_selling',
          'inStock': true,
          'stockCount': 45,
          'rating': 4.6,
          'reviewCount': 20,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': null,
        },
        {
          'id': 'product_5',
          'name': 'Watermelon',
          'description': 'Sweet and juicy watermelon, perfect for summer.',
          'price': 3.50,
          'quantity': '1pc',
          'imagePath': 'assets/images/watermelon.jpg',
          'category': 'Fresh Fruits & Vegetable',
          'section': 'best_selling',
          'inStock': true,
          'stockCount': 30,
          'rating': 4.9,
          'reviewCount': 50,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': null,
        },
      ];

      // Add each product to Firestore
      for (var product in initialProducts) {
        await _firestore.collection('products').doc(product['id']).set(product);
        print('✅ Added product: ${product['name']}');
      }

      print('🎉 All products initialized successfully!');
    } catch (e) {
      print('❌ Error initializing products: $e');
      rethrow;
    }
  }
}