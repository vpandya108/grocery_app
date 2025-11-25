import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/services/database_service.dart';
import 'package:grocery_app/models/product_model.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final DatabaseService _databaseService = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  int quantity = 1;
  bool _isAddingToCart = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final product = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (product == null) return;

    final productId = product['id']?.toString() ?? '';
    if (productId.isEmpty) return;

    final isFav = await _databaseService.isFavorite(currentUser.uid, productId);
    setState(() {
      _isFavorite = isFav;
    });
  }

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  Future<void> _addToCart(
    BuildContext context,
    Map<String, dynamic> product,
    int itemQuantity,
  ) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to add items to cart'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isAddingToCart = true;
    });

    try {
      final productId = product['id']?.toString() ?? 'product_${DateTime.now().millisecondsSinceEpoch}';
      final cartItemId = '${currentUser.uid}_$productId';

      final cartItem = CartItem(
        id: cartItemId,
        userId: currentUser.uid,
        productId: productId,
        productName: product['name'] ?? 'Unknown Product',
        productImage: product['imagePath'] ?? 'assets/images/placeholder.jpg',
        price: (product['price'] ?? 0.0).toDouble(),
        quantity: product['quantity'] ?? 'N/A',
        itemCount: itemQuantity,
        addedAt: DateTime.now(),
      );

      await _databaseService.addToCart(currentUser.uid, cartItem);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added $itemQuantity × ${product['name']} to cart!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'VIEW CART',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/cart_page');
              },
            ),
          ),
        );
      }

      // Reset quantity after adding
      setState(() {
        quantity = 1;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding to cart: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite(String productId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to add favorites'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      if (_isFavorite) {
        await _databaseService.removeFromFavorites(currentUser.uid, productId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from favorites'),
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        await _databaseService.addToFavorites(currentUser.uid, productId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to favorites'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }

      setState(() {
        _isFavorite = !_isFavorite;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Product data not found!')),
      );
    }

    final String name = product['name'] ?? 'Unknown Product';
    final String quantityText = product['quantity'] ?? 'N/A';
    final double price = (product['price'] ?? 0.0).toDouble();
    final String imagePath = product['imagePath'] ?? 'assets/images/placeholder.jpg';
    final String productDetail = product['description'] ?? 'No product description available.';
    final String productId = product['id']?.toString() ?? '';
    final String displayPrice = '\$${price.toStringAsFixed(2)}';

    const String nutritionValue = '100gr';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.grey[100],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Padding(
                padding: const EdgeInsets.only(top: 80.0, bottom: 20.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.fastfood,
                    size: 150,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name and Favourite Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorite ? Colors.red : Colors.grey,
                            size: 28,
                          ),
                          onPressed: () => _toggleFavorite(productId),
                        ),
                      ],
                    ),

                    // Quantity Text
                    Text(
                      '$quantityText, Price',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),

                    const SizedBox(height: 30),

                    // Quantity Selector and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Quantity Selector
                        Row(
                          children: [
                            _buildQuantityButton(Icons.remove, _decrementQuantity),
                            Container(
                              width: 45,
                              alignment: Alignment.center,
                              child: Text(
                                '$quantity',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _buildQuantityButton(Icons.add, _incrementQuantity),
                          ],
                        ),

                        // Price
                        Text(
                          displayPrice,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                    const Divider(height: 1, thickness: 1),
                    const SizedBox(height: 20),

                    // Product Detail Section
                    const Text(
                      'Product Detail',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      productDetail,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),

                    const SizedBox(height: 20),
                    const Divider(height: 1, thickness: 1),

                    // Nutrition Section
                    _buildInfoRow(
                      'Nutritions',
                      trailing: Row(
                        children: [
                          Text(
                            nutritionValue,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      onTap: () {
                        debugPrint('Navigate to Nutrition details');
                      },
                    ),

                    const Divider(height: 1, thickness: 1),

                    // Review Section
                    _buildInfoRow(
                      'Review',
                      trailing: Row(
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.star, color: Colors.orange, size: 20),
                              Icon(Icons.star, color: Colors.orange, size: 20),
                              Icon(Icons.star, color: Colors.orange, size: 20),
                              Icon(Icons.star, color: Colors.orange, size: 20),
                              Icon(Icons.star_half, color: Colors.orange, size: 20),
                            ],
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      onTap: () {
                        debugPrint('Navigate to Reviews');
                      },
                    ),

                    const Divider(height: 1, thickness: 1),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(25.0),
        child: ElevatedButton(
          onPressed: _isAddingToCart
              ? null
              : () => _addToCart(context, product, quantity),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: _isAddingToCart
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Add To Basket',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Icon(icon, color: Colors.green),
      ),
    );
  }

  Widget _buildInfoRow(
    String title, {
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}