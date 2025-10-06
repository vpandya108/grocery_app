import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // NOTE: This _currentIndex is only used for the state of this screen.
  // The BottomNavigationBar's 'currentIndex' is fixed at 0 for this page.
  // int _currentIndex = 0; // Removed as it's not used to control the NavBar index here

  // Add a list of banner images
  final List<String> bannerImages = const [
    'assets/images/grocery_back.jpg',
    'assets/images/banner5.webp',
    'assets/images/banner7.jpeg',
  ];

  // Dummy data structure for products
  final List<Map<String, dynamic>> products = const [
    {
      'id': 1,
      'name': 'Organic Bananas',
      'quantity': '7pcs',
      'price': 4.99,
      'imagePath': 'assets/images/banana.jpg',
      'section': 'exclusive',
      'description':
          'Premium organic bananas, naturally sweet and packed with potassium. Perfect for smoothies or a quick, healthy snack.',
    },
    {
      'id': 2,
      'name': 'Red Apple',
      'quantity': '1kg',
      'price': 4.99,
      'imagePath': 'assets/images/apple.jpg',
      'section': 'exclusive',
    },
    // --- NEW ITEM ADDED ---
    {
      'id': 6,
      'name': 'Organic Cucumber',
      'quantity': '1pc',
      'price': 1.99,
      'imagePath': 'assets/images/cucumber.jpg', // Assuming you have this asset
      'section': 'exclusive',
    },
    // ----------------------
    {
      'id': 3,
      'name': 'Bell Pepper Red',
      'quantity': '1kg',
      'price': 4.99,
      'imagePath': 'assets/images/bell_paper.jpeg',
      'section': 'best_selling',
    },
    {
      'id': 4,
      'name': 'Ginger',
      'quantity': '250gm',
      'price': 4.99,
      'imagePath': 'assets/images/ginger.jpeg',
      'section': 'best_selling',
    },
    {
      'id': 5,
      'name': 'Watermelon',
      'quantity': '1pc',
      'price': 3.50,
      'imagePath': 'assets/images/watermelon.jpg',
      'section': 'best_selling',
    },
  ];

  // Handle BottomNavigationBar taps
  void _onItemTapped(int index) {
    // The current index for HomeScreen (Shop tab) is fixed at 0.
    if (index == 0) return;

    // Define routes for each index
    String routeName;
    switch (index) {
      case 0:
        routeName = '/home_screen'; // Shop
        break;
      case 1:
        routeName = '/explore_page'; // Explore
        break;
      case 2:
        routeName = '/cart_page'; // Cart
        break;
      case 3:
        routeName = '/favourite_page'; // Favourite
        break;
      case 4:
        routeName = '/account_page'; // Account
        break;
      default:
        return; // Should not happen
    }

    // Use pushReplacementNamed for main tab navigation to prevent a growing stack
    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // FIX 1: Ensure the entire title block is centered
        title: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Ensures contents are centered
          children: [
            Image.asset(
              'assets/images/grocery.png', // Add your logo image
              height: 30,
              errorBuilder: (context, error, stackTrace) => const Text(
                'GROCERY',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on_outlined, color: Colors.black, size: 16),
                SizedBox(width: 4),
                Text(
                  'rajkot,360020',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar (User can search by typing here)
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
                onSubmitted: (query) {
                  // Implement search functionality, e.g., navigate to results page
                  debugPrint('Searching for: $query');
                },
              ),
              const SizedBox(height: 20),

              // Carousel Banner (FIXED FIT)
              CarouselSlider(
                options: CarouselOptions(
                  height: 150.0, // Increased height for better visibility
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 1.0, // Ensures full width fit
                ),
                items: bannerImages.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage(i),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Exclusive Offer Section
              _buildSectionTitle(context, 'Exclusive Offer', 'exclusive'),
              const SizedBox(height: 10),
              _buildProductList(context, section: 'exclusive'),
              const SizedBox(height: 20),

              // Best Selling Section
              _buildSectionTitle(context, 'Best Selling', 'best_selling'),
              const SizedBox(height: 10),
              _buildProductList(context, section: 'best_selling'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        // The HomeScreen is the Shop tab, which is index 0
        currentIndex: 0,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
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
      ),
    );
  }

  // Section Title with "See All" button
  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    String sectionKey,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {
            // CHANGED: Navigating to a hypothetical /product_list_page
            // instead of /explore_page to differentiate this action from the main tab.
            debugPrint('Navigating to See All for $title');
            Navigator.pushNamed(
              context,
              '/product_list_page', // Use a dedicated route for product lists
              arguments: {'category': title, 'section': sectionKey},
            );
          },
          child: const Text(
            'See all',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // Creates the horizontal list view of product cards
  Widget _buildProductList(BuildContext context, {required String section}) {
    final filteredProducts = products
        .where((p) => p['section'] == section)
        .toList();

    return SizedBox(
      // Height set to 245 to prevent overflow.
      height: 245,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: _buildProductCard(context, product),
          );
        },
      ),
    );
  }

  // Single product card with onTap navigation
  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        // Navigate to the product detail page, passing the full product data
        Navigator.pushNamed(context, '/product_detail', arguments: product);
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          // FIX 2: Use Spacer to push the final Row to the bottom
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                // Use a fixed-height container for the image/placeholder
                child: SizedBox(
                  height: 80,
                  child: Image.asset(
                    product['imagePath'],
                    fit: BoxFit
                        .contain, // Ensure the image fits within the fixed space
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.shopping_basket,
                      size: 80,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Product Name
              Text(
                product['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              // Product Quantity
              Text(
                product['quantity'],
                style: const TextStyle(color: Colors.grey),
              ),

              const Spacer(), // Pushes everything below it to the bottom
              // Price and Add to Cart Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${product['price']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('Added ${product['name']} to cart!');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(0),
                      minimumSize: const Size(40, 40),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
