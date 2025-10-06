import 'package:flutter/material.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  // Default values for the quantity counter
  int quantity = 1;

  // Function to increment the quantity
  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  // Function to decrement the quantity, ensuring it doesn't go below 1
  void _decrementQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Retrieve the product data passed via arguments
    final product =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    // Handle case where product data might be missing (shouldn't happen if navigating correctly)
    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Product data not found!')),
      );
    }

    // Safely extract data, using defaults if keys are missing
    final String name = product['name'] ?? 'Unknown Product';
    final String quantityText = product['quantity'] ?? 'N/A';
    final double price = product['price'] ?? 0.00;
    final String imagePath =
        product['imagePath'] ?? 'assets/images/placeholder.jpg';

    // The price shown on the screen is the unit price, not total price
    final String displayPrice = '\$${price.toStringAsFixed(2)}';

    // Placeholder product detail and nutrition data (for demonstration)
    const String productDetail =
        'Apples Are Nutritious. Apples May Be Good For Weight Loss. Apples May Be Good For Your Heart. As Part Of A Healtful And Varied Diet.';
    const String nutritionValue = '100gr';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 2. Custom App Bar for the Image
          SliverAppBar(
            expandedHeight:
                MediaQuery.of(context).size.height *
                0.4, // 40% of screen height
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

          // 3. Product Details Section
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
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.grey,
                            size: 28,
                          ),
                          onPressed: () {
                            // Handle favourite toggle
                          },
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
                            _buildQuantityButton(
                              Icons.remove,
                              _decrementQuantity,
                            ),
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
                            // Star Rating
                            children: [
                              Icon(Icons.star, color: Colors.orange, size: 20),
                              Icon(Icons.star, color: Colors.orange, size: 20),
                              Icon(Icons.star, color: Colors.orange, size: 20),
                              Icon(Icons.star, color: Colors.orange, size: 20),
                              Icon(
                                Icons.star_half,
                                color: Colors.orange,
                                size: 20,
                              ),
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
                    const SizedBox(
                      height: 100,
                    ), // Space for the floating button
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),

      // 4. Floating 'Add to Basket' Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(25.0),
        child: ElevatedButton(
          onPressed: () {
            // Handle Add to Basket logic here
            debugPrint('Added $quantity x $name to basket!');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text(
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

  // Helper widget for the quantity selector buttons
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

  // Helper widget for Nutrition/Review rows
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
