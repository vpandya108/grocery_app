import 'package:flutter/material.dart';

// Note: You will need to ensure your main.dart file has the correct named routes set up
// for all the new category pages (e.g., /products/fruits_vegetables).

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  // Define the consistent green color
  final Color primaryGreen = const Color(0xFF53B175);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Find Products",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Store',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),
            // Categories Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildCategoryCard(
                  context,
                  'Fresh Fruits & Vegetable',
                  'assets/images/vegetables.jpg',
                  const Color(0xFF53B175),
                  // New Route for this category
                  '/products/fruits_vegetables',
                ),
                _buildCategoryCard(
                  context,
                  'Cooking Oil & Ghee',
                  'assets/images/oil.jpg',
                  const Color(0xFFF8A44C),
                  '/products/oil_ghee',
                ),
                _buildCategoryCard(
                  context,
                  'Bakery & Snacks',
                  'assets/images/snacks.jpg',
                  const Color(0xFFD3A4F4),
                  '/products/bakery_snacks',
                ),
                _buildCategoryCard(
                  context,
                  'Dairy',
                  'assets/images/dairy.png',
                  const Color(0xFFF7A593),
                  '/products/dairy',
                ),
                _buildCategoryCard(
                  context,
                  'Beverages',
                  'assets/images/beverages.webp',
                  const Color(0xFFB7DFF5),
                  '/products/beverages',
                ),
                _buildCategoryCard(
                  context,
                  ' Snacks', // Changed 'Snacks' to 'Meat & Fish' for variety
                  'assets/images/snacks.jpg', // Placeholder image path
                  const Color(0xFF81C784),
                  '/products/snacks',
                ),
              ],
            ),
          ],
        ),
      ),
      // --- Bottom Navigation Bar remains unchanged ---
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryGreen, // Use consistent green color
        unselectedItemColor: Colors.black,
        currentIndex: 1, // Explore is index 1
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            // Use filled icon to indicate current page
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home_screen');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/cart_page');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/favourite_page');
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/account_page');
          }
          // index 1 (Explore) is the current page, so we do nothing.
        },
      ),
    );
  }

  // UPDATED: Now takes context and routeName
  Widget _buildCategoryCard(
    BuildContext context,
    String name,
    String imagePath,
    Color color,
    String routeName,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate to the CategoryProductsPage using a named route
        // We pass the category name so the next page can display the correct title
        Navigator.pushNamed(
          context,
          '/category_products', // A single route name for all categories
          arguments: name, // Pass the category name as an argument
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color, width: 2.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 90, fit: BoxFit.contain),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
