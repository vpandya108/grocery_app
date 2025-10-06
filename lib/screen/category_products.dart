import 'package:flutter/material.dart';

// Data model for a single product item
class Product {
  final String name;
  final String imagePath;
  final double price;

  Product({required this.name, required this.imagePath, required this.price});
}

// Sample data to populate the grid, mimicking the products in the image
final List<Product> dummyProducts = [
  Product(
    name: 'Tomotoes',
    imagePath: 'assets/images/tomato.jpeg',
    price: 3.99,
  ),
  Product(
    name: 'Sweet Bell Peppers',
    imagePath: 'assets/images/bell_paper.jpeg',
    price: 4.20,
  ),
  Product(
    name: 'Broccoli',
    imagePath: 'assets/images/brocoli.jpg',
    price: 4.90,
  ),
  Product(name: 'Bananas', imagePath: 'assets/images/banana.jpg', price: 4.20),
  Product(
    name: 'Strawberries',
    imagePath: 'assets/images/strawberry.jpeg',
    price: 5.00,
  ),
  Product(name: 'Avocado', imagePath: 'assets/images/avocado.jpg', price: 3.80),
];

class CategoryProducts extends StatelessWidget {
  final String categoryName;

  // Use the consistent primary green color from your app's theme
  final Color primaryGreen = const Color.fromRGBO(83, 177, 117, 1);

  // The categoryName is passed in the constructor
  const CategoryProducts({Key? key, required this.categoryName})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom AppBar with the green background and category name
          _buildSliverAppBar(context),

          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio:
                    0.75, // Adjust this ratio to match the card height
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = dummyProducts[index % dummyProducts.length];
                  return _buildProductCard(product);
                },
                childCount:
                    6, // Example: display 10 items (will repeat dummy data)
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build the top AppBar area
  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: primaryGreen,
      expandedHeight: 180.0, // Height of the expanded header area
      pinned: true, // Keeps the App Bar visible at the top
      elevation: 0,
      automaticallyImplyLeading: false, // Control leading explicitly

      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16.0, bottom: 40.0),
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              categoryName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const Text(
              '6 Items', // Hardcoded for the demo image
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.sort,
            color: Colors.white,
          ), // Using sort icon for filter
          onPressed: () {
            // Filter logic here
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              left: 16.0,
              right: 16.0,
              bottom: 10.0,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search here',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.blueGrey,
                    width: 1.0,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build a single product card
  Widget _buildProductCard(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], // Light grey background for the whole card
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          // Product Image (as seen in the image, the product image takes up most of the card)
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              product.imagePath,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              // Use a dark filter/gradient to make the text pop
              color: Colors.black.withOpacity(0.3),
              colorBlendMode: BlendMode.darken,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                alignment: Alignment.center,
                child: const Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
          ),

          // Details (Price and Name at the bottom)
          Positioned(
            bottom: 15,
            left: 10,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),

          // Favorite Icon (Heart) at the top left
          Positioned(
            top: 10,
            left: 10,
            child: Icon(
              Icons.favorite, // Assuming filled heart is for favorited
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

// NOTE: Remember to add the assets/images paths to your pubspec.yaml file 
// and create placeholder images (e.g., tomatoes.jpg, broccoli.jpg) 
// in the 'assets/images' folder for this code to run without errors.